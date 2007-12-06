Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbXLFIiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbXLFIiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXLFIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:37:55 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49570 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXLFIhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:37:53 -0500
Message-ID: <4757B4AA.7000003@ak.jp.nec.com>
Date: Thu, 06 Dec 2007 17:36:58 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4754D76B.8080406@ak.jp.nec.com> <4754F053.8060303@kernel.org> <4755701C.7070407@ak.jp.nec.com> <4756C436.706@kernel.org> <47575AB1.5090501@ak.jp.nec.com> <47578AFC.7040702@kernel.org>
In-Reply-To: <47578AFC.7040702@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai Kohei wrote:
>> BTW, could you tell me your intention about pam_cap.c is implemented
>> with pam_sm_authenticate() and pam_sm_setcred()?
>> I think it can be done with pam_sm_open_session(), and this approach
>> enables to reduce the iteration of reading /etc/security/capability.conf.
>>
>> How do you think the idea?
> 
> Good question! If you want to add session support you can. I'd prefer it
> if you retained support for the auth/cred API too: admin choice and all
> that. To remove the second read of the file, you can use a PAM data item
> to cache the desired capability info after the first read of the file.

I added session API support with retaining auth/cred API, and
PAM data item caching feature using pam_(get|set)_data. It enables to
kill the seconf read of the configuration file.

Thanks for your suggestion.
Followings are detailed explanation and the patch.

> I implemented it as a credential module (which has to get the
> authentication return code right to make the credential stack execute
> correctly) because I think of capabilities as credentials.
> 
> That being said, the credentials vs. session thing is not well
> delineated by many applications, so it is arguably useful to provide
> both interfaces for the admin to make use of on a per application basis.

The attached patch provides several improvement for pam_cap module.
1. It enables pam_cap to drop capabilities from process'es capability
    bounding set.
2. It enables to specify allowing inheritable capability set or dropping
    bounding capability set for groups, not only users.
3. It provide pam_sm_session() method, not only pam_sm_authenticate()
    and pam_sm_setcred(). A system administrator can select more
    appropriate mode for his purpose.
4. In the auth/cred mode, it enables to cache the configuration file,
    to avoid read and analyze it twice.
(Therefore, most of the part in the original one got replaced....)

The default configuration file is "/etc/security/capability.conf".
You can describe as follows:
--------
# kaigai get cap_net_raw and cap_kill, tak get cap_sys_pacct pI.
# We can omit "i:" in the head of each line.
i:cap_net_raw,cap_kill         kaigai
cap_sys_pacct                  tak

# ymj and tak lost cap_sys_chroot from cap_bset
b:cap_sys_chroot               ymj  tak

# Any user within webadm group get cap_net_bind_service pI.
i:cap_net_bind_service         @webadm

# Any user within users group lost cap_sys_module from cap_bset
b:cap_sys_module               @users
--------

When a user or groups he belongs is on several lines, all configurations
are simplly compounded.

In the above example, if tak belongs to webadm and users group,
he will get cap_sys_pacct and cap_net_bind_service pI, and lost
cap_sys_chroot and cap_sys_module from his cap_bset.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>


Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
--
  pam_cap/capability.conf |    6 +
  pam_cap/pam_cap.c       |  495 ++++++++++++++++++++++++++++-------------------
  2 files changed, 305 insertions(+), 196 deletions(-)

diff --git a/pam_cap/capability.conf b/pam_cap/capability.conf
index b543142..707cdc3 100644
--- a/pam_cap/capability.conf
+++ b/pam_cap/capability.conf
@@ -24,6 +24,12 @@ cap_setfcap		morgan
  ## 'everyone else' gets no inheritable capabilities
  none  *

+# user 'kaigai' lost CAP_NET_RAW capability from bounding set
+b:cap_net_raw                   kaigai
+
+# group 'acctadm' get CAP_SYS_PACCT inheritable capability
+i:cap_sys_pacct                 @acctadm
+
  ## if there is no '*' entry, all users not explicitly mentioned will
  ## get all available capabilities. This is a permissive default, and
  ## probably not what you want...
diff --git a/pam_cap/pam_cap.c b/pam_cap/pam_cap.c
index 94c5ebc..a917d5c 100644
--- a/pam_cap/pam_cap.c
+++ b/pam_cap/pam_cap.c
@@ -1,5 +1,6 @@
  /*
   * Copyright (c) 1999,2007 Andrew G. Morgan <morgan@kernel.org>
+ * Copyright (c) 2007      KaiGai Kohei <kaigai@ak.jp.nec.com>
   *
   * The purpose of this module is to enforce inheritable capability sets
   * for a specified user.
@@ -13,298 +14,400 @@
  #include <stdarg.h>
  #include <stdlib.h>
  #include <syslog.h>
+#include <pwd.h>
+#include <grp.h>

  #include <sys/capability.h>
+#include <sys/prctl.h>

  #include <security/pam_modules.h>
  #include <security/_pam_macros.h>

+#define MODULE_NAME		"pam_cap"
  #define USER_CAP_FILE           "/etc/security/capability.conf"
  #define CAP_FILE_BUFFER_SIZE    4096
  #define CAP_FILE_DELIMITERS     " \t\n"
-#define CAP_COMBINED_FORMAT     "%s all-i %s+i"
-#define CAP_DROP_ALL            "%s all-i"
+
+#ifndef PR_CAPBSET_DROP
+#define PR_CAPBSET_DROP		24
+#endif
+
+extern char const *_cap_names[];

  struct pam_cap_s {
      int debug;
      const char *user;
      const char *conf_filename;
+    /* set in read_capabilities_for_user() */
+    cap_t result;
+    int do_set_inh : 1;
+    int do_set_bset : 1;
  };

-/* obtain the inheritable capabilities for the current user */
-
-static char *read_capabilities_for_user(const char *user, const char *source)
+/* obtain the inheritable/bounding capabilities for the current user */
+static int read_capabilities_for_user(struct pam_cap_s *pcs)
  {
-    char *cap_string = NULL;
-    char buffer[CAP_FILE_BUFFER_SIZE], *line;
+    char buffer[CAP_FILE_BUFFER_SIZE];
      FILE *cap_file;
+    struct passwd *pwd;
+    int line_num = 0;
+    int rc = -1;	/* PAM_(AUTH|CRED|SESSION)_ERR */
+
+    pwd = getpwnam(pcs->user);
+    if (!pwd) {
+	syslog(LOG_ERR, "user %s not in passwd entries", pcs->user);
+	return PAM_AUTH_ERR;
+    }

-    cap_file = fopen(source, "r");
-    if (cap_file == NULL) {
-	D(("failed to open capability file"));
-	return NULL;
+    cap_file = fopen(pcs->conf_filename, "r");
+    if (!cap_file) {
+	if (errno == ENOENT) {
+	    syslog(LOG_NOTICE, "%s is not found",
+		   pcs->conf_filename);
+	    return PAM_IGNORE;
+	} else {
+	    syslog(LOG_ERR, "unable to open '%s' (%s)",
+		   pcs->conf_filename, strerror(errno));
+	    return rc;
+	}
      }

-    while ((line = fgets(buffer, CAP_FILE_BUFFER_SIZE, cap_file))) {
-	int found_one = 0;
-	const char *cap_text;
+    pcs->result = NULL;
+    while (fgets(buffer, CAP_FILE_BUFFER_SIZE, cap_file) != NULL) {
+	char *pos, *cap_text;
+	int matched = 0;
+	int line_ops = CAP_INHERITABLE;

-	cap_text = strtok(line, CAP_FILE_DELIMITERS);
+	line_num++;

-	if (cap_text == NULL) {
-	    D(("empty line"));
-	    continue;
-	}
-	if (*cap_text == '#') {
-	    D(("comment line"));
+	/* remove comment */
+	pos = strchr(buffer, '#');
+	if (pos)
+	    *pos = '\0';
+
+	cap_text = strtok(buffer, CAP_FILE_DELIMITERS);
+	/* empty line */
+	if (!cap_text)
  	    continue;
+
+	if (!strncmp(cap_text, "b:", 2)) {
+	    /* permitted field is used to store bounding set */
+	    line_ops = CAP_PERMITTED;
+	    cap_text += 2;
+	} else if (!strncmp(cap_text, "i:", 2)) {
+	    cap_text += 2;
  	}

-	while ((line = strtok(NULL, CAP_FILE_DELIMITERS))) {
+	/* check members */
+	while ((pos = strtok(NULL, CAP_FILE_DELIMITERS)) != NULL) {
+	    /* wildcard */
+	    if (!strcmp("*", pos)) {
+		matched = 1;
+		break;
+	    }

-	    if (strcmp("*", line) == 0) {
-		D(("wildcard matched"));
-		found_one = 1;
-		cap_string = strdup(cap_text);
+	    /* It it group name? */
+	    if (*pos == '@') {
+		struct group *grp;
+		int i;
+
+		pos++;
+		grp = getgrnam(pos);
+		if (!grp) {
+		    if (pcs->debug)
+			syslog(LOG_DEBUG, "group '%s' not found at line:%d",
+			       pos, line_num);
+		    continue;
+		}
+
+		if (pwd->pw_gid == grp->gr_gid) {
+		    if (pcs->debug)
+			syslog(LOG_DEBUG, "user %s matched with group %s at line:%d",
+			       pcs->user, pos, line_num);
+		    matched = 1;
+		    break;
+		}
+
+		for (i=0; grp->gr_mem[i]; i++) {
+		    if (!strcmp(pcs->user, grp->gr_mem[i])) {
+			if (pcs->debug)
+			    syslog(LOG_DEBUG, "user %s matched with group %s at line:%d",
+				   pcs->user, pos, line_num);
+			matched = 1;
+			break;
+		    }
+		}
+		syslog(LOG_ERR, "no matching %s", pos);
+	    } else if (!strcmp(pcs->user, pos)) {
+		if (pcs->debug)
+		    syslog(LOG_DEBUG, "user '%s' matched at line:%d",
+			   pos, line_num);
+		matched = 1;
  		break;
  	    }
+	}
+
+	if (matched) {
+	    char tmpbuf[CAP_FILE_BUFFER_SIZE];
+	    cap_t tmp;
+	    cap_value_t value;
+	    cap_flag_value_t code;
+
+	    if (!pcs->result) {
+		pcs->result = cap_init();
+		if (!pcs->result) {
+		    syslog(LOG_ERR, "unable to allocate cap_t object (%s)",
+			   strerror(errno));
+		    goto out;
+		}
+	    }

-	    if (strcmp(user, line) == 0) {
-		D(("exact match for user"));
-		found_one = 1;
-		cap_string = strdup(cap_text);
+	    switch (line_ops) {
+	    case CAP_INHERITABLE:
+		pcs->do_set_inh = 1;
+		break;
+	    case CAP_PERMITTED:
+		pcs->do_set_bset = 1;
  		break;
  	    }

-	    D(("user is not [%s] - skipping", line));
+	    if (!strcmp(cap_text, "none"))
+		continue;
+
+	    snprintf(tmpbuf, sizeof(tmpbuf), "%s=p", cap_text);
+	    tmp = cap_from_text(tmpbuf);
+	    if (!tmp) {
+		syslog(LOG_ERR, "unable to convert '%s' (%s)",
+		       tmpbuf, strerror(errno));
+		cap_free(pcs->result);
+		pcs->result = NULL;
+		goto out;
+	    }
+
+	    for (value=0; ;value++) {
+		if (cap_get_flag(tmp, value, CAP_PERMITTED, &code) < 0)
+		    break;	/* If value == __CAP_BITS, we get EINVAL */
+		if (code == CAP_SET)
+		    cap_set_flag(pcs->result, line_ops, 1, &value, CAP_SET);
+	    }
+	    cap_free(tmp);
  	}
+    }

-	cap_text = NULL;
-	line = NULL;
+    if (pcs->debug) {
+	char *tmp = cap_to_text(pcs->result, NULL);

-	if (found_one) {
-	    D(("user [%s] matched - caps are [%s]", user, cap_string));
-	    break;
-	}
+	syslog(LOG_DEBUG, "configuration for user %s is %s",
+	       pcs->user, tmp);
+	cap_free(tmp);
      }
+    rc = PAM_SUCCESS;

+  out:
      fclose(cap_file);

-    memset(buffer, 0, CAP_FILE_BUFFER_SIZE);
-
-    return cap_string;
+    return rc;
  }

  /*
   * Set capabilities for current process to match the current
   * permitted+executable sets combined with the configured inheritable
- * set.
+ * and bounding set.
   */

-static int set_capabilities(struct pam_cap_s *cs)
+static int set_capabilities(struct pam_cap_s *pcs)
  {
-    cap_t cap_s;
-    ssize_t length = 0;
-    char *conf_icaps;
-    char *proc_epcaps;
-    char *combined_caps;
-    int ok = 0;
-
-    cap_s = cap_get_proc();
-    if (cap_s == NULL) {
-	D(("your kernel is capability challenged - upgrade: %s",
-	   strerror(errno)));
-	return 0;
-    }
-
-    conf_icaps =
-	read_capabilities_for_user(cs->user,
-				   cs->conf_filename
-				   ? cs->conf_filename:USER_CAP_FILE );
-    if (conf_icaps == NULL) {
-	D(("no capabilities found for user [%s]", cs->user));
-	goto cleanup_cap_s;
-    }
-
-    proc_epcaps = cap_to_text(cap_s, &length);
-    if (proc_epcaps == NULL) {
-	D(("unable to convert process capabilities to text"));
-	goto cleanup_icaps;
-    }
-
-    /*
-     * This is a pretty inefficient way to combine
-     * capabilities. However, it seems to be the most straightforward
-     * one, given the limitations of the POSIX.1e draft spec. The spec
-     * is optimized for applications that know the capabilities they
-     * want to manipulate at compile time.
-     */
-
-    combined_caps = malloc(1+strlen(CAP_COMBINED_FORMAT)
-			   +strlen(proc_epcaps)+strlen(conf_icaps));
-    if (combined_caps == NULL) {
-	D(("unable to combine capabilities into one string - no memory"));
-	goto cleanup_epcaps;
-    }
-
-    if (!strcmp(conf_icaps, "none")) {
-	sprintf(combined_caps, CAP_DROP_ALL, proc_epcaps);
-    } else if (!strcmp(conf_icaps, "all")) {
-	/* no change */
-	sprintf(combined_caps, "%s", proc_epcaps);
-    } else {
-	sprintf(combined_caps, CAP_COMBINED_FORMAT, proc_epcaps, conf_icaps);
-    }
-    D(("combined_caps=[%s]", combined_caps));
-
-    cap_free(cap_s);
-    cap_s = cap_from_text(combined_caps);
-    _pam_overwrite(combined_caps);
-    _pam_drop(combined_caps);
-
-#ifdef DEBUG
-    {
-        char *temp = cap_to_text(cap_s, NULL);
-	D(("abbreviated caps for process will be [%s]", temp));
-	cap_free(temp);
-    }
-#endif /* DEBUG */
-
-    if (cap_s == NULL) {
-	D(("no capabilies to set"));
-    } else if (cap_set_proc(cap_s) == 0) {
-	D(("capabilities were set correctly"));
-	ok = 1;
-    } else {
-	D(("failed to set specified capabilities: %s", strerror(errno)));
-    }
-
-cleanup_epcaps:
-    cap_free(proc_epcaps);
-
-cleanup_icaps:
-    _pam_overwrite(conf_icaps);
-    _pam_drop(conf_icaps);
+    cap_value_t value;
+    cap_flag_value_t code;
+    int rc = -1;	/* PAM_(AUTH|CRED|SESSION)_ERR */
+
+    /* set inheritable capability set */
+    if (pcs->do_set_inh) {
+	cap_t cap_s = cap_get_proc();
+	if (!cap_s) {
+	    syslog(LOG_ERR, "your kernel is capability challenged - upgrade: %s",
+		   strerror(errno));
+	    goto out;
+	}
+	for (value=0; ;value++) {
+	    if (cap_get_flag(pcs->result, value, CAP_INHERITABLE, &code))
+		break;
+	    cap_set_flag(cap_s, CAP_INHERITABLE, 1, &value, code);
+	}
+	if (cap_set_proc(cap_s) < 0) {
+	    if (errno == EPERM)
+		rc = PAM_PERM_DENIED;
+	    syslog(LOG_ERR, "unable to set inheritable capabilities (%s)",
+		   strerror(errno));
+	    cap_free(cap_s);
+	    goto out;
+	}
+	if (pcs->debug) {
+	    char *tmp = cap_to_text(cap_s, NULL);

-cleanup_cap_s:
-    if (cap_s) {
+	    syslog(LOG_DEBUG, "user %s new capabilities: %s",
+		   pcs->user, tmp);
+	    cap_free(tmp);
+	}
  	cap_free(cap_s);
-	cap_s = NULL;
      }
+    /* drop capability bounding set */
+    if (pcs->do_set_bset) {
+	for (value=0; ;value++) {
+	    if (cap_get_flag(pcs->result, value, CAP_PERMITTED, &code))
+		break;
+	    if (code == CAP_SET) {
+		if (prctl(PR_CAPBSET_DROP, value) < 0) {
+		    syslog(LOG_ERR, "unable to drop capability b-set %u (%s)",
+			   value, strerror(errno));
+		    goto out;
+		}
+		if (pcs->debug)
+		    syslog(LOG_DEBUG, "%s drops capability %s from bounding set",
+			   pcs->user, _cap_names[value]);
+	    }
+	}
+    }
+    rc = PAM_SUCCESS;

-    return ok;
-}
-
-/* log errors */
-
-static void _pam_log(int err, const char *format, ...)
-{
-    va_list args;
+  out:
+    cap_free(pcs->result);

-    va_start(args, format);
-    openlog("pam_cap", LOG_CONS|LOG_PID, LOG_AUTH);
-    vsyslog(err, format, args);
-    va_end(args);
-    closelog();
+    return rc;
  }

-static void parse_args(int argc, const char **argv, struct pam_cap_s *pcs)
+static int init_pam_cap(pam_handle_t *pamh, int argc, const char **argv,
+			struct pam_cap_s *pcs)
  {
-    int ctrl=0;
+    int ctrl, rc;
+
+    /* Initialization */
+    memset(pcs, 0, sizeof(struct pam_cap_s));
+    pcs->conf_filename = USER_CAP_FILE;
+    rc = pam_get_user(pamh, &pcs->user, NULL);
+    if (rc == PAM_CONV_AGAIN) {
+	syslog(LOG_INFO, "user conversation is not available yet");
+	return PAM_INCOMPLETE;
+    }
+    if (rc != PAM_SUCCESS) {
+	syslog(LOG_INFO, "pam_get_user failed: %s", pam_strerror(pamh, rc));
+	return -1;
+    }

      /* step through arguments */
      for (ctrl=0; argc-- > 0; ++argv) {
-
  	if (!strcmp(*argv, "debug")) {
  	    pcs->debug = 1;
  	} else if (!strcmp(*argv, "config=")) {
  	    pcs->conf_filename = strlen("config=") + *argv;
  	} else {
-	    _pam_log(LOG_ERR, "unknown option; %s", *argv);
+	    syslog(LOG_ERR, "unknown option: %s", *argv);
+	    return -1;
  	}
+    }
+    return PAM_SUCCESS;
+}

+static void cleanup_pam_cap(pam_handle_t *pamh, void *data, int error_status)
+{
+    struct pam_cap_s *pcs = (struct pam_cap_s *) data;
+
+    if (pcs) {
+	if (pcs->result)
+	    cap_free(pcs->result);
+	free(pcs);
      }
  }

  int pam_sm_authenticate(pam_handle_t *pamh, int flags,
  			int argc, const char **argv)
  {
-    int retval;
-    struct pam_cap_s pcs;
-    char *conf_icaps;
+    struct pam_cap_s *pcs = NULL;
+    int rc = PAM_BUF_ERR;

-    memset(&pcs, 0, sizeof(pcs));
+    openlog(MODULE_NAME, LOG_CONS|LOG_PID, LOG_AUTHPRIV);

-    parse_args(argc, argv, &pcs);
+    pcs = malloc(sizeof(struct pam_cap_s));
+    if (!pcs)
+	goto error;

-    retval = pam_get_user(pamh, &pcs.user, NULL);
+    rc = init_pam_cap(pamh, argc, argv, pcs);
+    if (rc != PAM_SUCCESS)
+	goto error;

-    if (retval == PAM_CONV_AGAIN) {
-	D(("user conversation is not available yet"));
-	memset(&pcs, 0, sizeof(pcs));
-	return PAM_INCOMPLETE;
-    }
+    rc = read_capabilities_for_user(pcs);
+    if (rc != PAM_SUCCESS)
+	goto error;

-    if (retval != PAM_SUCCESS) {
-	D(("pam_get_user failed: %s", pam_strerror(pamh, retval)));
-	memset(&pcs, 0, sizeof(pcs));
-	return PAM_AUTH_ERR;
+    rc = pam_set_data(pamh, MODULE_NAME, pcs, cleanup_pam_cap);
+    if (rc == PAM_SUCCESS) {
+	/* OK, pam_sm_setcred() will be called next */
+	closelog();
+	return rc;
      }

-    conf_icaps =
-	read_capabilities_for_user(pcs.user,
-				   pcs.conf_filename
-				   ? pcs.conf_filename:USER_CAP_FILE );
-
-    memset(&pcs, 0, sizeof(pcs));
-
-    if (conf_icaps) {
-	D(("it appears that there are capabilities for this user [%s]",
-	   conf_icaps));
+  error:
+    cleanup_pam_cap(pamh, pcs, rc);
+    closelog();
+    return rc < 0 ? PAM_AUTH_ERR : rc;
+}

-	/* We could also store this as a pam_[gs]et_data item for use
-	   by the setcred call to follow. As it is, there is a small
-	   race associated with a redundant read. Oh well, if you
-	   care, send me a patch.. */
+int pam_sm_setcred(pam_handle_t *pamh, int flags,
+		   int argc, const char **argv)
+{
+    struct pam_cap_s *pcs = NULL;
+    int rc = PAM_IGNORE;

-	_pam_overwrite(conf_icaps);
-	_pam_drop(conf_icaps);
+    openlog(MODULE_NAME, LOG_CONS|LOG_PID, LOG_AUTHPRIV);

-	return PAM_SUCCESS;
+    if (!(flags & PAM_ESTABLISH_CRED))
+	goto out;

-    } else {
+    rc = pam_get_data(pamh, MODULE_NAME, (void *)&pcs);
+    if (rc != PAM_SUCCESS)
+	return rc;

-	D(("there are no capabilities restrctions on this user"));
-	return PAM_IGNORE;
+    rc = set_capabilities(pcs);

-    }
+  out:
+    closelog();
+    return rc < 0 ? PAM_CRED_ERR : rc;
  }

-int pam_sm_setcred(pam_handle_t *pamh, int flags,
-		   int argc, const char **argv)
+int pam_sm_open_session(pam_handle_t *pamh, int flags,
+			int argc, const char **argv)
  {
-    int retval;
      struct pam_cap_s pcs;
+    int rc;

-    if (!(flags & PAM_ESTABLISH_CRED)) {
-	D(("we don't handle much in the way of credentials"));
-	return PAM_IGNORE;
-    }
+    openlog(MODULE_NAME, LOG_CONS|LOG_PID, LOG_AUTHPRIV);

-    memset(&pcs, 0, sizeof(pcs));
+    rc = init_pam_cap(pamh, argc, argv, &pcs);
+    if (rc != PAM_SUCCESS)
+	goto out;

-    parse_args(argc, argv, &pcs);
+    rc = read_capabilities_for_user(&pcs);
+    if (rc != PAM_SUCCESS)
+	goto out;

-    retval = pam_get_item(pamh, PAM_USER, (const void **)&pcs.user);
-    if ((retval != PAM_SUCCESS) || (pcs.user == NULL) || !(pcs.user[0])) {
+    rc = set_capabilities(&pcs);

-	D(("user's name is not set"));
-	return PAM_AUTH_ERR;
+    if (rc == PAM_SUCCESS) {
+	rc = set_capabilities(&pcs);
+	if (pcs.result)
+	    cap_free(pcs.result);
      }

-    retval = set_capabilities(&pcs);
+  out:
+    if (pcs.result)
+	cap_free(pcs.result);
+    closelog();

-    memset(&pcs, 0, sizeof(pcs));
+    return rc < 0 ? PAM_SESSION_ERR : rc;
+}

-    return (retval ? PAM_SUCCESS:PAM_IGNORE );
+int pam_sm_close_session(pam_handle_t *pamh, int flags,
+			 int argc, const char **argv)
+{
+    return PAM_SUCCESS; /* do nothing */
  }

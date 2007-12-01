Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbXLABrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbXLABrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbXLABrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:47:18 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:29324 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756424AbXLABrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:47:17 -0500
X-Greylist: delayed 1621 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 20:47:17 EST
Message-ID: <4750B6D5.7070607@kaigai.gr.jp>
Date: Sat, 01 Dec 2007 10:20:21 +0900
From: KaiGai Kohei <kaigai@kaigai.gr.jp>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com>
In-Reply-To: <20071126200908.GA13287@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> The capability bounding set is a set beyond which capabilities
> cannot grow.  Currently cap_bset is per-system.  It can be
> manipulated through sysctl, but only init can add capabilities.
> Root can remove capabilities.  By default it includes all caps
> except CAP_SETPCAP.

Serge,

This feature makes me being interested in.
I think you intend to apply this feature for the primary process
of security container.
However, it is also worthwhile to apply when a session is starting up.

The following PAM module enables to drop capability bounding bit
specified by the fifth field in /etc/passwd entry.
This code is just an example now, but considerable feature.

build and install:
# gcc -Wall -c pam_cap_drop.c
# gcc -Wall -shared -Xlinker -x -o pam_cap_drop.so pam_cap_drop.o -lpam
# cp pam_cap_drop.so /lib/security

modify /etc/passwd as follows:

tak:x:1004:100:cap_drop=cap_net_raw,cap_chown:/home/tak:/bin/bash
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
example:
[kaigai@masu ~]$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.23 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=1.02 ms

--- 192.168.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 1.023/1.130/1.237/0.107 ms

[kaigai@masu ~]$ ssh tak@localhost
tak@localhost's password:
Last login: Sat Dec  1 10:09:29 2007 from masu.myhome.cx
[tak@masu ~]$ export LANG=C
[tak@masu ~]$ ping 192.168.1.1
ping: icmp open socket: Operation not permitted

[tak@masu ~]$ su
Password:
pam_cap_bset[6921]: user root does not have 'cap_drop=' property
[root@masu tak]# cat /proc/self/status | grep ^Cap
CapInh: 0000000000000000
CapPrm: 00000000ffffdffe
CapEff: 00000000ffffdffe
[root@masu tak]#

# BTW, I replaced the James's address in the Cc: list,
# because MTA does not accept it.
-- 
KaiGai Kohei <kaigai@kaigai.gr.jp>

************************************************************
    pam_cap_drop.c
************************************************************

/*
 * pam_cap_drop.c module -- drop capabilities bounding set
 *
 * Copyright: 2007 KaiGai Kohei <kaigai@kaigai.gr.jp>
 */

#include <errno.h>
#include <pwd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <syslog.h>
#include <sys/prctl.h>
#include <sys/types.h>

#include <security/pam_modules.h>

#ifndef PR_CAPBSET_DROP
#define PR_CAPBSET_DROP 24
#endif

static char *captable[] = {
	"cap_chown",
	"cap_dac_override",
	"cap_dac_read_search",
	"cap_fowner",
	"cap_fsetid",
	"cap_kill",
	"cap_setgid",
	"cap_setuid",
	"cap_setpcap",
	"cap_linux_immutable",
	"cap_net_bind_service",
	"cap_net_broadcast",
	"cap_net_admin",
	"cap_net_raw",
	"cap_ipc_lock",
	"cap_ipc_owner",
	"cap_sys_module",
	"cap_sys_rawio",
	"cap_sys_chroot",
	"cap_sys_ptrace",
	"cap_sys_pacct",
	"cap_sys_admin",
	"cap_sys_boot",
	"cap_sys_nice",
	"cap_sys_resource",
	"cap_sys_time",
	"cap_sys_tty_config",
	"cap_mknod",
	"cap_lease",
	"cap_audit_write",
	"cap_audit_control",
	"cap_setfcap",
	NULL,
};


PAM_EXTERN int
pam_sm_open_session(pam_handle_t *pamh, int flags,
                    int argc, const char **argv)
{
	struct passwd *pwd;
	char *pos, *buf;
	char *username = NULL;

	/* open system logger */
	openlog("pam_cap_bset", LOG_PERROR | LOG_PID, LOG_AUTHPRIV);

	/* get the unix username */
	if (pam_get_item(pamh, PAM_USER, (void *) &username) != PAM_SUCCESS || !username)
		return PAM_USER_UNKNOWN;

	/* get the passwd entry */
	pwd = getpwnam(username);
	if (!pwd)
		return PAM_USER_UNKNOWN;

	/* Is there "cap_drop=" ? */
	pos = strstr(pwd->pw_gecos, "cap_drop=");
	if (pos) {
		buf = strdup(pos + sizeof("cap_drop=") - 1);
		if (!buf)
			return PAM_SESSION_ERR;
		pos = strtok(buf, ",");
		while (pos) {
			int rc, i;

			for (i=0; captable[i]; i++) {
				if (!strcmp(pos, captable[i])) {
					rc = prctl(PR_CAPBSET_DROP, i);
					if (rc < 0) {
						syslog(LOG_NOTICE, "user %s could not drop %s (%s)",
						       username, captable[i], strerror(errno));
						break;
					}
					syslog(LOG_NOTICE, "user %s drops %s\n", username, captable[i]);
					goto next;
				}
			}
			break;
		next:
			pos = strtok(NULL, ",");
		}
		free(buf);
	} else {
		syslog(LOG_NOTICE, "user %s does not have 'cap_drop=' property", username);
	}
	return PAM_SUCCESS;
}

PAM_EXTERN int
pam_sm_close_session(pam_handle_t *pamh, int flags,
                     int argc, const char **argv)
{
	/* do nothing */
	return PAM_SUCCESS;
}

************************************************************

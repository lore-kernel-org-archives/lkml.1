Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYHMBtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYHMBtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHMBtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:49:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:11467 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYHMBtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=BPk3a1yWqfRqVblkEzrOAEvX1Zq5WQxveraKfzx1qnj52SWEeggGvk6SmLwH/PPjm6
         r+mfLHgtksuZDZl4pJKq9hYxEhvjHa+ohnULVG41C6yK4f1nzw5Rk6Kl5Oja1ot35dLo
         HQMqCp9anuOebEDfsm+W3FJkRrqcwG8C/TAvg=
From: Bruce Duncan <bwduncan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [git pull] ftrace for v2.6.27
Date: Wed, 13 Aug 2008 02:48:51 +0100
User-Agent: KMail/1.9.9
References: <20080714142226.GA11412@elte.hu>
In-Reply-To: <20080714142226.GA11412@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2459498.8X1sRTNKkb";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808130248.58216.bwduncan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2459498.8X1sRTNKkb
Content-Type: multipart/mixed;
  boundary="Boundary-01=_G2joIBnNKNSB6T8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_G2joIBnNKNSB6T8
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo, Steven, everyone,

[ Please CC me in replies ]

I have just tracked down a regression in 2.6.27-rc2 wrt 2.6.26. Commit=20
77a2b37d227483fe52aead242652aee406c25bf0 (ftrace: startup tester on dynamic=
=20
tracing.) causes my laptop to fail to resume from S3 (it simply reboots abo=
ut=20
a second after the resume starts and the display never shows anything).

The patch doesn't revert with patch -R (I don't know if there's a cleverer =
way=20
to ask git to revert it), but the problem goes away if I turn off=20
CONFIG_DYNAMIC_FTRACE.

The commit and bisect log are attached. Please can you help me to debug thi=
s?

Cheers,
Bruce

--Boundary-01=_G2joIBnNKNSB6T8
Content-Type: text/plain;
  charset="iso 8859-15";
  name="bad-commit.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="bad-commit.txt"

commit 77a2b37d227483fe52aead242652aee406c25bf0
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon May 12 21:20:45 2008 +0200

    ftrace: startup tester on dynamic tracing.
   =20
    This patch adds a startup self test on dynamic code modification
    and filters. The test filters on a specific function, makes sure that
    no other function is traced, exectutes the function, then makes sure th=
at
    the function is traced.
   =20
    This patch also fixes a slight bug with the ftrace selftest, where
    tracer_enabled was not being set.
   =20
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 953a36d..a842d96 100644
=2D-- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -55,6 +55,7 @@ struct dyn_ftrace {
 };
=20
 int ftrace_force_update(void);
+void ftrace_set_filter(unsigned char *buf, int len, int reset);
=20
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
@@ -70,6 +71,7 @@ extern void ftrace_call(void);
 extern void mcount_call(void);
 #else
 # define ftrace_force_update() ({ 0; })
+# define ftrace_set_filter(buf, len, reset) do { } while (0)
 #endif
=20
 static inline void tracer_disable(void)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6d4d2e8..5e9389f 100644
=2D-- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1010,6 +1010,25 @@ ftrace_filter_write(struct file *file, const char __=
user *ubuf,
 	return ret;
 }
=20
+/**
+ * ftrace_set_filter - set a function to filter on in ftrace
+ * @buf - the string that holds the function filter text.
+ * @len - the length of the string.
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Filters denote which functions should be enabled when tracing is enable=
d.
+ * If @buf is NULL and reset is set, all functions will be enabled for tra=
cing.
+ */
+notrace void ftrace_set_filter(unsigned char *buf, int len, int reset)
+{
+	mutex_lock(&ftrace_filter_lock);
+	if (reset)
+		ftrace_filter_reset();
+	if (buf)
+		ftrace_match(buf, len);
+	mutex_unlock(&ftrace_filter_lock);
+}
+
 static int notrace
 ftrace_filter_release(struct inode *inode, struct file *file)
 {
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index c01874c..4c8a1b2 100644
=2D-- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -99,6 +99,100 @@ static int trace_test_buffer(struct trace_array *tr, un=
signed long *count)
 }
=20
 #ifdef CONFIG_FTRACE
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+#define DYN_FTRACE_TEST_NAME trace_selftest_dynamic_test_func
+#define __STR(x) #x
+#define STR(x) __STR(x)
+static int DYN_FTRACE_TEST_NAME(void)
+{
+	/* used to call mcount */
+	return 0;
+}
+
+/* Test dynamic code modification and ftrace filters */
+int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
+					   struct trace_array *tr,
+					   int (*func)(void))
+{
+	unsigned long count;
+	int ret;
+	int save_ftrace_enabled =3D ftrace_enabled;
+	int save_tracer_enabled =3D tracer_enabled;
+
+	/* The ftrace test PASSED */
+	printk(KERN_CONT "PASSED\n");
+	pr_info("Testing dynamic ftrace: ");
+
+	/* enable tracing, and record the filter function */
+	ftrace_enabled =3D 1;
+	tracer_enabled =3D 1;
+
+	/* passed in by parameter to fool gcc from optimizing */
+	func();
+
+	/* update the records */
+	ret =3D ftrace_force_update();
+	if (ret) {
+		printk(KERN_CONT ".. ftraced failed .. ");
+		return ret;
+	}
+
+	/* filter only on our function */
+	ftrace_set_filter(STR(DYN_FTRACE_TEST_NAME),
+			  sizeof(STR(DYN_FTRACE_TEST_NAME)), 1);
+
+	/* enable tracing */
+	tr->ctrl =3D 1;
+	trace->init(tr);
+	/* Sleep for a 1/10 of a second */
+	msleep(100);
+
+	/* we should have nothing in the buffer */
+	ret =3D trace_test_buffer(tr, &count);
+	if (ret)
+		goto out;
+
+	if (count) {
+		ret =3D -1;
+		printk(KERN_CONT ".. filter did not filter .. ");
+		goto out;
+	}
+
+	/* call our function again */
+	func();
+
+	/* sleep again */
+	msleep(100);
+
+	/* stop the tracing. */
+	tr->ctrl =3D 0;
+	trace->ctrl_update(tr);
+	ftrace_enabled =3D 0;
+
+	/* check the trace buffer */
+	ret =3D trace_test_buffer(tr, &count);
+	trace->reset(tr);
+
+	/* we should only have one item */
+	if (!ret && count !=3D 1) {
+		printk(KERN_CONT ".. filter failed ..");
+		ret =3D -1;
+		goto out;
+	}
+ out:
+	ftrace_enabled =3D save_ftrace_enabled;
+	tracer_enabled =3D save_tracer_enabled;
+
+	/* Enable tracing on all functions again */
+	ftrace_set_filter(NULL, 0, 1);
+
+	return ret;
+}
+#else
+# define trace_selftest_startup_dynamic_tracing(trace, tr, func) ({ 0; })
+#endif /* CONFIG_DYNAMIC_FTRACE */
 /*
  * Simple verification test of ftrace function tracer.
  * Enable ftrace, sleep 1/10 second, and then read the trace
@@ -109,8 +203,13 @@ trace_selftest_startup_function(struct tracer *trace, =
struct trace_array *tr)
 {
 	unsigned long count;
 	int ret;
+	int save_ftrace_enabled =3D ftrace_enabled;
+	int save_tracer_enabled =3D tracer_enabled;
=20
=2D	/* make sure functions have been recorded */
+	/* make sure msleep has been recorded */
+	msleep(1);
+
+	/* force the recorded functions to be traced */
 	ret =3D ftrace_force_update();
 	if (ret) {
 		printk(KERN_CONT ".. ftraced failed .. ");
@@ -119,6 +218,7 @@ trace_selftest_startup_function(struct tracer *trace, s=
truct trace_array *tr)
=20
 	/* start the tracing */
 	ftrace_enabled =3D 1;
+	tracer_enabled =3D 1;
=20
 	tr->ctrl =3D 1;
 	trace->init(tr);
@@ -136,8 +236,16 @@ trace_selftest_startup_function(struct tracer *trace, =
struct trace_array *tr)
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
 		ret =3D -1;
+		goto out;
 	}
=20
+	ret =3D trace_selftest_startup_dynamic_tracing(trace, tr,
+						     DYN_FTRACE_TEST_NAME);
+
+ out:
+	ftrace_enabled =3D save_ftrace_enabled;
+	tracer_enabled =3D save_tracer_enabled;
+
 	return ret;
 }
 #endif /* CONFIG_FTRACE */
@@ -415,6 +523,3 @@ trace_selftest_startup_sched_switch(struct tracer *trac=
e, struct trace_array *tr
 	return ret;
 }
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
=2D
=2D#ifdef CONFIG_DYNAMIC_FTRACE
=2D#endif /* CONFIG_DYNAMIC_FTRACE */

--Boundary-01=_G2joIBnNKNSB6T8
Content-Type: text/x-log;
  charset="iso 8859-15";
  name="bisect.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bisect.log"

# bad: [6e86841d05f371b5b9b86ce76c02aaee83352298] Linux 2.6.27-rc1
# good: [bce7f793daec3e65ec5c5705d2457b81fe7b5725] Linux 2.6.26
git-bisect start 'v2.6.27-rc1' 'v2.6.26'
# bad: [d20b27478d6ccf7c4c8de4f09db2bdbaec82a6c0] V4L/DVB (8415): gspca: Infinite loop in i2c_w() of etoms.
git-bisect bad d20b27478d6ccf7c4c8de4f09db2bdbaec82a6c0
# bad: [666484f0250db2e016948d63b3ef33e202e3b8d0] Merge branch 'core/softirq' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad 666484f0250db2e016948d63b3ef33e202e3b8d0
# good: [d59fdcf2ac501de99c3dfb452af5e254d4342886] Merge commit 'v2.6.26' into x86/core
git-bisect good d59fdcf2ac501de99c3dfb452af5e254d4342886
# good: [a3da5bf84a97d48cfaf66c6842470fc403da5121] Merge branch 'x86/for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect good a3da5bf84a97d48cfaf66c6842470fc403da5121
# bad: [6712e299b7dc78aa4971b85e803435ee6d49a9dd] Merge branch 'tracing/ftrace' into auto-ftrace-next
git-bisect bad 6712e299b7dc78aa4971b85e803435ee6d49a9dd
# bad: [4823ed7eadf35e4b57ce581327e21d39585f1f32] ftrace: fix setting of pos in read_pipe
git-bisect bad 4823ed7eadf35e4b57ce581327e21d39585f1f32
# bad: [9ff9cdb2d3b0971f89e899b3420aadd91bddc215] ftrace: cleanups
git-bisect bad 9ff9cdb2d3b0971f89e899b3420aadd91bddc215
# good: [c7aafc549766b87819285d3480648fc652a47bc4] ftrace: cleanups
git-bisect good c7aafc549766b87819285d3480648fc652a47bc4
# skip: [f9896bf30928922a3913a3810a4ab7908da6cfe7] ftrace: add raw output
git-bisect skip f9896bf30928922a3913a3810a4ab7908da6cfe7
# skip: [8c523a9d82dbc4f3f7d972df8c0f1eacd83d0d55] ftrace: clean-up-pipe-iteration
git-bisect skip 8c523a9d82dbc4f3f7d972df8c0f1eacd83d0d55
# skip: [cb0f12aae8d085140d37ada351aa5a8e76c3f9b0] ftrace: bin-output
git-bisect skip cb0f12aae8d085140d37ada351aa5a8e76c3f9b0
# skip: [cdd31cd2d7a0dcbec2cce3974f7129dd4fc8c879] ftrace: remove-idx-sync
git-bisect skip cdd31cd2d7a0dcbec2cce3974f7129dd4fc8c879
# skip: [f0a920d5752e1788c0cba2add103076bcc0f7a49] ftrace: add trace_special()
git-bisect skip f0a920d5752e1788c0cba2add103076bcc0f7a49
# skip: [53c37c17aafcf50f7c6fddaf01dda8f9d7e31ddf] ftrace: fast, scalable, synchronized timestamps
git-bisect skip 53c37c17aafcf50f7c6fddaf01dda8f9d7e31ddf
# skip: [dcb6308f2b56720599f6b9d5a01c33e67e69bde4] ftrace, locking fix
git-bisect skip dcb6308f2b56720599f6b9d5a01c33e67e69bde4
# skip: [088b1e427dbba2af93cb6a7d39258c10ff58dd27] ftrace: pipe fixes
git-bisect skip 088b1e427dbba2af93cb6a7d39258c10ff58dd27
# bad: [750ed1a40783432d0dcb0e6c2e813a12615d7664] ftrace: timestamp syncing, prepare
git-bisect bad 750ed1a40783432d0dcb0e6c2e813a12615d7664
# bad: [1d4db00a5e30c7b8f8dc2a1b19e886fd942be143] ftrace: reset selftests
git-bisect bad 1d4db00a5e30c7b8f8dc2a1b19e886fd942be143
# bad: [4e3c3333f3bd7eedfd21b1155b3c7cd24fc7f754] ftrace: fix time offset
git-bisect bad 4e3c3333f3bd7eedfd21b1155b3c7cd24fc7f754
# bad: [77a2b37d227483fe52aead242652aee406c25bf0] ftrace: startup tester on dynamic tracing.
git-bisect bad 77a2b37d227483fe52aead242652aee406c25bf0
# good: [7bd2f24c2f769e3f8f1d4fc8b9fddf689825f6a7] ftrace: add README
git-bisect good 7bd2f24c2f769e3f8f1d4fc8b9fddf689825f6a7

--Boundary-01=_G2joIBnNKNSB6T8--

--nextPart2459498.8X1sRTNKkb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIC+TCCAvUw
ggJeoAMCAQICECvawsxeeZNuMlZfJi3IhGwwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDUyMDEyMDk0OFoXDTA5MDUyMDEyMDk0
OFowWzEPMA0GA1UEBBMGRHVuY2FuMQ4wDAYDVQQqEwVCcnVjZTEVMBMGA1UEAxMMQnJ1Y2UgRHVu
Y2FuMSEwHwYJKoZIhvcNAQkBFhJid2R1bmNhbkBnbWFpbC5jb20wggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDO1bkRhjwX+pJ4TpMPyCAdx1gbIEra1PLRGn2kwkLvHAxAwuDenLs8v5Su
0fJtYe/TBOkB5r7i191UArkXKFl5W22TfJ0EOsgFNa9H8Sy2u4Kg8YwMNNHb0OR6SBMZgwFGPzi0
t3Fh3YhxACxIOvX2/yf+2kznozvvwwVjd0qqcHm3J7dsrZgMssyRQ1MH5RJng0yRRLCuOk6Zani7
OvnOvzkGLlOkBEP03DBCm2Ub3vuUBiBqxmU//b9pMkGqnSCRCW+2cpBpVqQeg5TVLsLf5PnJ1dnQ
3qzzzBqqy0fP0bfPPkB5TqJbqY6kD0fpFLjDZ4Max4QU2ZXdTXHJPL0RAgMBAAGjLzAtMB0GA1Ud
EQQWMBSBEmJ3ZHVuY2FuQGdtYWlsLmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GB
AFPGdehtL/fiPsN/miK35Jfn3W5rfpdKr7ytdaK9X5Ft/9ECkWb9f268xKMJgZRTB9oU2G4X5iBM
0+xc2fR0be1YnbZroeZBTw6H6cN/UJAHoA07CIM2EVKvWbgvui89BQBly6Fv7JI1KIeYYig+sho3
HgVQ2JqX60wDFIYRSzgAMYICJzCCAiMCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhh
d3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0ECECvawsxeeZNuMlZfJi3IhGwwBwYFKw4DAhqggYswGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwODEzMDE0ODU0WjAjBgkqhkiG9w0BCQQx
FgQUBFaSG+rZpxpwDMkHcZZ82rzvl0QwLAYJKoZIhvcNAQkPMR8wHTANBglghkgBZQMEAQIFADAM
BggqhkiG9w0DBwUAMAsGCSqGSIb3DQEBAQSCAQB4DJ+N8izPN5Vuj/5DnUND+NfHwMz02vQpiS3e
tloY2mUZqwbqyggha545FPZgKs4ZsLf5Uj6l+0MkjWwoYs97wF+n/0dentG/9lBRMwnoQQ6uzKUs
MlrrfftHIFsiDtKkLOd6qbca4Tjs/AEwEwuCZBkw0dUSlzworY6yVpy+wWDVpbtQHkL1poRV0SWd
Nx+WG9xw6iaPHbbj8NpQ7yhUWPgRO0H/MSrXyN5QIqMwkeOHRmk2CtV6hejVnudSdaXHWP0sbrLH
spR7H4e4d/WwsFjgtUIlBBHNxzMBHgyhCF2qjvKo+M2C39gOjIqrovKLglc36sEbOdrEeQdh7u7s
AAAAAAAA

--nextPart2459498.8X1sRTNKkb--

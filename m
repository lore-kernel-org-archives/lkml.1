Return-Path: <linux-kernel-owner+w=401wt.eu-S1764347AbZFQNkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764347AbZFQNkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZFQNkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:40:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:35281 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZFQNkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:40:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bpQBdhphcFkliCONrfgWIu0gr+Pupkh/uKxgtDnGn440CM5j8981vgbTrEMzm/OnfE
         tNNgVwVLXQ68j1+/hyuUxA9+43+tleZc7T0ejNrm3P+jxJWV7xhzW1Gg9rJUUEcscLID
         O5ATqNj1u/WK9lsaESq2KNGcUqnUTQ3xH+vWg=
MIME-Version: 1.0
Date: Wed, 17 Jun 2009 19:10:42 +0530
Message-ID: <f5a7b3810906170640w7f737318n95e1f6cbf807e316@mail.gmail.com>
Subject: [ARM-SIGNAL]open_posix_testcase-nanosleep+SIGCONT+SIGSTOP+Failed
From: naresh kamboju <naresh.kernel@gmail.com>
To: linux-arm@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>
Content-Type: multipart/mixed; boundary=001e680f12840162ef046c8b709c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f12840162ef046c8b709c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I want to inform 2.6.29 signal issues of ARM.
this issue is noticed only on ARM.

As per my understanding I have noticed that when there is a delay
(sleep/nanosleep/usleep) in the child process. Child could not
reporting exit status to parent at this situation parent is waiting
for ever by combinations of SIGSTOP and SIGCONT. So test cases are
reporting as HUNG.

Here I have attached open posix test cases which are reported as HUNG
with 2.6.29 kernels.
1.	ltp/testcases/open_posix_testsuite/conformance/interfaces/clock_nanosleep/1-5.c
2.	ltp/testcases/open_posix_testsuite/conformance/interfaces/nanosleep/3-2.c



ARCH: ARM
KERNEL: 2.6.29.1-alp_nl-kzm-arm11
Glibc: 2.9
Gcc: 4.3.3

/*****************************************************************/
 open_posix_testsuite/conformance/interfaces/clock_nanosleep/1-5.c

/*****************************************************************/
/*
 * Copyright (c) 2002-3, Intel Corporation. All rights reserved.
 * Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
 * This file is licensed under the GPL license.  For the full content
 * of this license, see the COPYING file at the top level of this
 * source tree.

 * Test that clock_nanosleep() does not stop if a signal is received
 * that has no signal handler.  clock_nanosleep() should still respond
 * to the signal, but should resume after a SIGCONT signal is received.
 *
 * SIGSTOP will be used to stop the sleep.
 */
#include <stdio.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include "posixtest.h"

#define SLEEPSEC 5

#define CHILDPASS 1
#define CHILDFAIL 0

int main(int argc, char *argv[])
{
	int pid, slepts;
	struct timespec tsbefore, tsafter;

	if (clock_gettime(CLOCK_REALTIME, &tsbefore) != 0) {
		perror("clock_gettime() did not return success\n");
		return PTS_UNRESOLVED;
	}


	if ((pid = fork()) == 0) {
		/* child here */
		struct timespec tssleep;

		tssleep.tv_sec=SLEEPSEC;
		tssleep.tv_nsec=0;
		if (clock_nanosleep(CLOCK_REALTIME, 0, &tssleep, NULL) == 0) {
			printf("clock_nanosleep() returned success\n");
			return CHILDPASS;
		} else {
			printf("clock_nanosleep() did not return success\n");
			return CHILDFAIL;
		}
		return CHILDFAIL;
	} else {
		/* parent here */
		int i;

		sleep(1);

		if (kill(pid, SIGSTOP) != 0) {
			printf("Could not raise SIGSTOP\n");
			return PTS_UNRESOLVED;
		}

		if (kill(pid, SIGCONT) != 0) {
			printf("Could not raise SIGCONT\n");
			return PTS_UNRESOLVED;
		}

		if (wait(&i) == -1) {
			perror("Error waiting for child to exit\n");
			return PTS_UNRESOLVED;
		}

		if (!WIFEXITED(i) || !WEXITSTATUS(i)) {
			printf("Test FAILED\n");
			return PTS_FAIL;
		}

		if (clock_gettime(CLOCK_REALTIME, &tsafter) == -1) {
			perror("Error in clock_gettime()\n");
			return PTS_UNRESOLVED;
		}

		slepts=tsafter.tv_sec-tsbefore.tv_sec;

#ifdef DEBUG
		printf("Start %d sec; End %d sec\n", (int) tsbefore.tv_sec,
				(int) tsafter.tv_sec);
#endif
		if (slepts >= SLEEPSEC) {
			printf("Test PASSED\n");
			return PTS_PASS;
		} else {
			printf("clock_nanosleep() did not sleep long enough\n");
			return PTS_FAIL;
		}

	} //end fork

	return PTS_UNRESOLVED;
}



/*****************************************************************/
 open_posix_testsuite/conformance/interfaces/nanosleep/3-2.c

/*****************************************************************/
/*
 * Copyright (c) 2002, Intel Corporation. All rights reserved.
 * Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
 * This file is licensed under the GPL license.  For the full content
 * of this license, see the COPYING file at the top level of this
 * source tree.
 *
 * Regression test motivated by an LKML discussion.  Test that nanosleep()
 * can be interrupted and then continue.
 */
#include <stdio.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define PTS_PASS        0
#define PTS_FAIL        1
#define PTS_UNRESOLVED  2
#define PTS_UNSUPPORTED 4
#define PTS_UNTESTED    5

#define SLEEPSEC 5

#define CHILDPASS 0 //if interrupted, child will return 0
#define CHILDFAIL 1

int main(int argc, char *argv[])
{
	int pid, slepts;
	struct timespec tsbefore, tsafter;

	if (clock_gettime(CLOCK_REALTIME, &tsbefore) != 0) {
		perror("clock_gettime() did not return success\n");
		return PTS_UNRESOLVED;
	}


	if ((pid = fork()) == 0) {
		/* child here */
		struct timespec tssleep;

		tssleep.tv_sec=SLEEPSEC;
		tssleep.tv_nsec=0;
		if (nanosleep(&tssleep, NULL) == 0) {
			printf("nanosleep() returned success\n");
			return CHILDPASS;
		} else {
			printf("nanosleep() did not return success\n");
			return CHILDFAIL;
		}
		return CHILDFAIL;
	} else {
		/* parent here */
		int i;

		sleep(1);

		if (kill(pid, SIGSTOP) != 0) {
			printf("Could not raise SIGSTOP\n");
			return PTS_UNRESOLVED;
		}

		if (kill(pid, SIGCONT) != 0) {
			printf("Could not raise SIGCONT\n");
			return PTS_UNRESOLVED;
		}

		if (wait(&i) == -1) {
			perror("Error waiting for child to exit\n");
			return PTS_UNRESOLVED;
		}

		if (!WIFEXITED(i)) {
			printf("nanosleep() did not return 0\n");
			return PTS_FAIL;
		}

		if (clock_gettime(CLOCK_REALTIME, &tsafter) == -1) {
			perror("Error in clock_gettime()\n");
			return PTS_UNRESOLVED;
		}

		slepts=tsafter.tv_sec-tsbefore.tv_sec;

		printf("Start %d sec; End %d sec\n", (int) tsbefore.tv_sec,
				(int) tsafter.tv_sec);
		if (slepts >= SLEEPSEC) {
			printf("Test PASSED\n");
			return PTS_PASS;
		} else {
			printf("nanosleep() did not sleep long enough\n");
			return PTS_FAIL;
		}

	} //end fork

	return PTS_UNRESOLVED;
}


/*****************************************************************/



Best regards,
Naresh Kamboju

--001e680f12840162ef046c8b709c
Content-Type: text/plain; charset=US-ASCII; name="proc_log.txt"
Content-Disposition: attachment; filename="proc_log.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw235pdd0

LWJhc2gtMy4yIyB1bmFtZSAtYQ0KTGludXggMi42LjI5LjIgDQotYmFzaC0zLjIjIGNhdCBwcm9j
LzQ2NC9zdGF0dXMNCk5hbWU6ICAgMy0yLnRlc3QNClN0YXRlOiAgVCAodHJhY2luZyBzdG9wKQ0K
VGdpZDogICA0NjQNClBpZDogICAgNDY0DQpQUGlkOiAgIDQ2Mg0KVHJhY2VyUGlkOiAgICAgIDQ2
Mg0KVWlkOiAgICAwICAgICAgIDAgICAgICAgMCAgICAgICAwDQpHaWQ6ICAgIDAgICAgICAgMCAg
ICAgICAwICAgICAgIDANCkZEU2l6ZTogMzINCkdyb3VwczogMA0KVm1QZWFrOiAgICAgMjMzMiBr
Qg0KVm1TaXplOiAgICAgMjMxNiBrQg0KVm1MY2s6ICAgICAgICAgMCBrQg0KVm1IV006ICAgICAg
IDQwNCBrQg0KVm1SU1M6ICAgICAgIDQwNCBrQg0KVm1EYXRhOiAgICAgICAzMiBrQg0KVm1TdGs6
ICAgICAgICA4NCBrQg0KVm1FeGU6ICAgICAgICAgNCBrQg0KVm1MaWI6ICAgICAgMjAzMiBrQg0K
Vm1QVEU6ICAgICAgICAgOCBrQg0KVGhyZWFkczogICAgICAgIDENClNpZ1E6ICAgMC8xMDI0DQpT
aWdQbmQ6IDAwMDAwMDAwMDAwMDAwMDANClNoZFBuZDogMDAwMDAwMDAwMDAwMDAwMA0KU2lnQmxr
OiAwMDAwMDAwMDAwMDAwMDAwDQpTaWdJZ246IDAwMDAwMDAwMDAwMDAwMDANClNpZ0NndDogMDAw
MDAwMDE4MDAwMDAwMA0KQ2FwSW5oOiAwMDAwMDAwMDAwMDAwMDAwDQpDYXBQcm06IGZmZmZmZmZm
ZmZmZmZlZmYNCkNhcEVmZjogZmZmZmZmZmZmZmZmZmVmZg0KQ2FwQm5kOiBmZmZmZmZmZmZmZmZm
ZWZmDQp2b2x1bnRhcnlfY3R4dF9zd2l0Y2hlczogICAgICAgIDEyNg0Kbm9udm9sdW50YXJ5X2N0
eHRfc3dpdGNoZXM6ICAgICAzMQ0KLWJhc2gtMy4yIw0KLWJhc2gtMy4yIyBjYXQgcHJvYy80NjUv
c3RhdHVzDQpOYW1lOiAgIDMtMi50ZXN0DQpTdGF0ZTogIFIgKHJ1bm5pbmcpDQpUZ2lkOiAgIDQ2
NQ0KUGlkOiAgICA0NjUNClBQaWQ6ICAgNDY0DQpUcmFjZXJQaWQ6ICAgICAgNDYyDQpVaWQ6ICAg
IDAgICAgICAgMCAgICAgICAwICAgICAgIDANCkdpZDogICAgMCAgICAgICAwICAgICAgIDAgICAg
ICAgMA0KRkRTaXplOiAzMg0KR3JvdXBzOiAwDQpWbVBlYWs6ICAgICAyMzE2IGtCDQpWbVNpemU6
ICAgICAyMzE2IGtCDQpWbUxjazogICAgICAgICAwIGtCDQpWbUhXTTogICAgICAgMTY0IGtCDQpW
bVJTUzogICAgICAgMTY0IGtCDQpWbURhdGE6ICAgICAgIDMyIGtCDQpWbVN0azogICAgICAgIDg0
IGtCDQpWbUV4ZTogICAgICAgICA0IGtCDQpWbUxpYjogICAgICAyMDMyIGtCDQpWbVBURTogICAg
ICAgICA4IGtCDQpUaHJlYWRzOiAgICAgICAgMQ0KU2lnUTogICAwLzEwMjQNClNpZ1BuZDogMDAw
MDAwMDAwMDAwMDAwMA0KU2hkUG5kOiAwMDAwMDAwMDAwMDAwMDAwDQpTaWdCbGs6IDAwMDAwMDAw
MDAwMDAwMDANClNpZ0lnbjogMDAwMDAwMDAwMDAwMDAwMA0KU2lnQ2d0OiAwMDAwMDAwMTgwMDAw
MDAwDQpDYXBJbmg6IDAwMDAwMDAwMDAwMDAwMDANCkNhcFBybTogZmZmZmZmZmZmZmZmZmVmZg0K
Q2FwRWZmOiBmZmZmZmZmZmZmZmZmZWZmDQpDYXBCbmQ6IGZmZmZmZmZmZmZmZmZlZmYNCnZvbHVu
dGFyeV9jdHh0X3N3aXRjaGVzOiAgICAgICAgNw0Kbm9udm9sdW50YXJ5X2N0eHRfc3dpdGNoZXM6
ICAgICAzNjYyMw0KLWJhc2gtMy4yIw==
--001e680f12840162ef046c8b709c
Content-Type: application/octet-stream; name="3-2.c"
Content-Disposition: attachment; filename="3-2.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw23610n1

LyogICANCiAqIENvcHlyaWdodCAoYykgMjAwMiwgSW50ZWwgQ29ycG9yYXRpb24uIEFsbCByaWdo
dHMgcmVzZXJ2ZWQuDQogKiBDcmVhdGVkIGJ5OiAganVsaWUubi5mbGVpc2NoZXIgUkVNT1ZFLVRI
SVMgQVQgaW50ZWwgRE9UIGNvbQ0KICogVGhpcyBmaWxlIGlzIGxpY2Vuc2VkIHVuZGVyIHRoZSBH
UEwgbGljZW5zZS4gIEZvciB0aGUgZnVsbCBjb250ZW50DQogKiBvZiB0aGlzIGxpY2Vuc2UsIHNl
ZSB0aGUgQ09QWUlORyBmaWxlIGF0IHRoZSB0b3AgbGV2ZWwgb2YgdGhpcyANCiAqIHNvdXJjZSB0
cmVlLg0KICoNCiAqIFJlZ3Jlc3Npb24gdGVzdCBtb3RpdmF0ZWQgYnkgYW4gTEtNTCBkaXNjdXNz
aW9uLiAgVGVzdCB0aGF0IG5hbm9zbGVlcCgpDQogKiBjYW4gYmUgaW50ZXJydXB0ZWQgYW5kIHRo
ZW4gY29udGludWUuDQogKi8NCiNpbmNsdWRlIDxzdGRpby5oPg0KI2luY2x1ZGUgPHRpbWUuaD4N
CiNpbmNsdWRlIDxzaWduYWwuaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxzeXMv
d2FpdC5oPg0KI2luY2x1ZGUgPHN0ZGxpYi5oPg0KDQojZGVmaW5lIFBUU19QQVNTICAgICAgICAw
DQojZGVmaW5lIFBUU19GQUlMICAgICAgICAxDQojZGVmaW5lIFBUU19VTlJFU09MVkVEICAyDQoj
ZGVmaW5lIFBUU19VTlNVUFBPUlRFRCA0DQojZGVmaW5lIFBUU19VTlRFU1RFRCAgICA1DQoNCiNk
ZWZpbmUgU0xFRVBTRUMgNQ0KDQojZGVmaW5lIENISUxEUEFTUyAwIC8vaWYgaW50ZXJydXB0ZWQs
IGNoaWxkIHdpbGwgcmV0dXJuIDANCiNkZWZpbmUgQ0hJTERGQUlMIDENCg0KaW50IG1haW4oaW50
IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkNCnsNCglpbnQgcGlkLCBzbGVwdHM7DQoJc3RydWN0IHRpbWVz
cGVjIHRzYmVmb3JlLCB0c2FmdGVyOw0KDQoJaWYgKGNsb2NrX2dldHRpbWUoQ0xPQ0tfUkVBTFRJ
TUUsICZ0c2JlZm9yZSkgIT0gMCkgew0KCQlwZXJyb3IoImNsb2NrX2dldHRpbWUoKSBkaWQgbm90
IHJldHVybiBzdWNjZXNzXG4iKTsNCgkJcmV0dXJuIFBUU19VTlJFU09MVkVEOw0KCX0NCg0KDQoJ
aWYgKChwaWQgPSBmb3JrKCkpID09IDApIHsNCgkJLyogY2hpbGQgaGVyZSAqLw0KCQlzdHJ1Y3Qg
dGltZXNwZWMgdHNzbGVlcDsNCg0KCQl0c3NsZWVwLnR2X3NlYz1TTEVFUFNFQzsNCgkJdHNzbGVl
cC50dl9uc2VjPTA7DQoJCWlmIChuYW5vc2xlZXAoJnRzc2xlZXAsIE5VTEwpID09IDApIHsNCgkJ
CXByaW50ZigibmFub3NsZWVwKCkgcmV0dXJuZWQgc3VjY2Vzc1xuIik7DQoJCQlyZXR1cm4gQ0hJ
TERQQVNTOw0KCQl9IGVsc2Ugew0KCQkJcHJpbnRmKCJuYW5vc2xlZXAoKSBkaWQgbm90IHJldHVy
biBzdWNjZXNzXG4iKTsNCgkJCXJldHVybiBDSElMREZBSUw7DQoJCX0NCgkJcmV0dXJuIENISUxE
RkFJTDsNCgl9IGVsc2Ugew0KCQkvKiBwYXJlbnQgaGVyZSAqLw0KCQlpbnQgaTsNCg0KCQlzbGVl
cCgxKTsNCg0KCQlpZiAoa2lsbChwaWQsIFNJR1NUT1ApICE9IDApIHsNCgkJCXByaW50ZigiQ291
bGQgbm90IHJhaXNlIFNJR1NUT1BcbiIpOw0KCQkJcmV0dXJuIFBUU19VTlJFU09MVkVEOw0KCQl9
DQoNCgkJaWYgKGtpbGwocGlkLCBTSUdDT05UKSAhPSAwKSB7DQoJCQlwcmludGYoIkNvdWxkIG5v
dCByYWlzZSBTSUdDT05UXG4iKTsNCgkJCXJldHVybiBQVFNfVU5SRVNPTFZFRDsNCgkJfQ0KDQoJ
CWlmICh3YWl0KCZpKSA9PSAtMSkgew0KCQkJcGVycm9yKCJFcnJvciB3YWl0aW5nIGZvciBjaGls
ZCB0byBleGl0XG4iKTsNCgkJCXJldHVybiBQVFNfVU5SRVNPTFZFRDsNCgkJfQ0KDQoJCWlmICgh
V0lGRVhJVEVEKGkpKSB7DQoJCQlwcmludGYoIm5hbm9zbGVlcCgpIGRpZCBub3QgcmV0dXJuIDBc
biIpOw0KCQkJcmV0dXJuIFBUU19GQUlMOw0KCQl9DQoNCgkJaWYgKGNsb2NrX2dldHRpbWUoQ0xP
Q0tfUkVBTFRJTUUsICZ0c2FmdGVyKSA9PSAtMSkgew0KCQkJcGVycm9yKCJFcnJvciBpbiBjbG9j
a19nZXR0aW1lKClcbiIpOw0KCQkJcmV0dXJuIFBUU19VTlJFU09MVkVEOw0KCQl9DQoNCgkJc2xl
cHRzPXRzYWZ0ZXIudHZfc2VjLXRzYmVmb3JlLnR2X3NlYzsNCg0KCQlwcmludGYoIlN0YXJ0ICVk
IHNlYzsgRW5kICVkIHNlY1xuIiwgKGludCkgdHNiZWZvcmUudHZfc2VjLA0KCQkJCShpbnQpIHRz
YWZ0ZXIudHZfc2VjKTsNCgkJaWYgKHNsZXB0cyA+PSBTTEVFUFNFQykgew0KCQkJcHJpbnRmKCJU
ZXN0IFBBU1NFRFxuIik7DQoJCQlyZXR1cm4gUFRTX1BBU1M7DQoJCX0gZWxzZSB7DQoJCQlwcmlu
dGYoIm5hbm9zbGVlcCgpIGRpZCBub3Qgc2xlZXAgbG9uZyBlbm91Z2hcbiIpOw0KCQkJcmV0dXJu
IFBUU19GQUlMOw0KCQl9DQoNCgl9IC8vZW5kIGZvcmsNCg0KCXJldHVybiBQVFNfVU5SRVNPTFZF
RDsNCn0NCg==
--001e680f12840162ef046c8b709c
Content-Type: application/octet-stream; name="1-5.c"
Content-Disposition: attachment; filename="1-5.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw236n882

LyogICANCiAqIENvcHlyaWdodCAoYykgMjAwMi0zLCBJbnRlbCBDb3Jwb3JhdGlvbi4gQWxsIHJp
Z2h0cyByZXNlcnZlZC4NCiAqIENyZWF0ZWQgYnk6ICBqdWxpZS5uLmZsZWlzY2hlciBSRU1PVkUt
VEhJUyBBVCBpbnRlbCBET1QgY29tDQogKiBUaGlzIGZpbGUgaXMgbGljZW5zZWQgdW5kZXIgdGhl
IEdQTCBsaWNlbnNlLiAgRm9yIHRoZSBmdWxsIGNvbnRlbnQNCiAqIG9mIHRoaXMgbGljZW5zZSwg
c2VlIHRoZSBDT1BZSU5HIGZpbGUgYXQgdGhlIHRvcCBsZXZlbCBvZiB0aGlzIA0KICogc291cmNl
IHRyZWUuDQoNCiAqIFRlc3QgdGhhdCBjbG9ja19uYW5vc2xlZXAoKSBkb2VzIG5vdCBzdG9wIGlm
IGEgc2lnbmFsIGlzIHJlY2VpdmVkDQogKiB0aGF0IGhhcyBubyBzaWduYWwgaGFuZGxlci4gIGNs
b2NrX25hbm9zbGVlcCgpIHNob3VsZCBzdGlsbCByZXNwb25kDQogKiB0byB0aGUgc2lnbmFsLCBi
dXQgc2hvdWxkIHJlc3VtZSBhZnRlciBhIFNJR0NPTlQgc2lnbmFsIGlzIHJlY2VpdmVkLg0KICoN
CiAqIFNJR1NUT1Agd2lsbCBiZSB1c2VkIHRvIHN0b3AgdGhlIHNsZWVwLg0KICovDQojaW5jbHVk
ZSA8c3RkaW8uaD4NCiNpbmNsdWRlIDx0aW1lLmg+DQojaW5jbHVkZSA8c2lnbmFsLmg+DQojaW5j
bHVkZSA8dW5pc3RkLmg+DQojaW5jbHVkZSA8c3lzL3dhaXQuaD4NCiNpbmNsdWRlIDxzdGRsaWIu
aD4NCiNpbmNsdWRlICJwb3NpeHRlc3QuaCINCg0KI2RlZmluZSBTTEVFUFNFQyA1DQoNCiNkZWZp
bmUgQ0hJTERQQVNTIDENCiNkZWZpbmUgQ0hJTERGQUlMIDANCg0KaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKmFyZ3ZbXSkNCnsNCglpbnQgcGlkLCBzbGVwdHM7DQoJc3RydWN0IHRpbWVzcGVjIHRz
YmVmb3JlLCB0c2FmdGVyOw0KDQoJaWYgKGNsb2NrX2dldHRpbWUoQ0xPQ0tfUkVBTFRJTUUsICZ0
c2JlZm9yZSkgIT0gMCkgew0KCQlwZXJyb3IoImNsb2NrX2dldHRpbWUoKSBkaWQgbm90IHJldHVy
biBzdWNjZXNzXG4iKTsNCgkJcmV0dXJuIFBUU19VTlJFU09MVkVEOw0KCX0NCg0KDQoJaWYgKChw
aWQgPSBmb3JrKCkpID09IDApIHsNCgkJLyogY2hpbGQgaGVyZSAqLw0KCQlzdHJ1Y3QgdGltZXNw
ZWMgdHNzbGVlcDsNCg0KCQl0c3NsZWVwLnR2X3NlYz1TTEVFUFNFQzsNCgkJdHNzbGVlcC50dl9u
c2VjPTA7DQoJCWlmIChjbG9ja19uYW5vc2xlZXAoQ0xPQ0tfUkVBTFRJTUUsIDAsICZ0c3NsZWVw
LCBOVUxMKSA9PSAwKSB7DQoJCQlwcmludGYoImNsb2NrX25hbm9zbGVlcCgpIHJldHVybmVkIHN1
Y2Nlc3NcbiIpOw0KCQkJcmV0dXJuIENISUxEUEFTUzsNCgkJfSBlbHNlIHsNCgkJCXByaW50Zigi
Y2xvY2tfbmFub3NsZWVwKCkgZGlkIG5vdCByZXR1cm4gc3VjY2Vzc1xuIik7DQoJCQlyZXR1cm4g
Q0hJTERGQUlMOw0KCQl9DQoJCXJldHVybiBDSElMREZBSUw7DQoJfSBlbHNlIHsNCgkJLyogcGFy
ZW50IGhlcmUgKi8NCgkJaW50IGk7DQoNCgkJc2xlZXAoMSk7DQoNCgkJaWYgKGtpbGwocGlkLCBT
SUdTVE9QKSAhPSAwKSB7DQoJCQlwcmludGYoIkNvdWxkIG5vdCByYWlzZSBTSUdTVE9QXG4iKTsN
CgkJCXJldHVybiBQVFNfVU5SRVNPTFZFRDsNCgkJfQ0KDQoJCWlmIChraWxsKHBpZCwgU0lHQ09O
VCkgIT0gMCkgew0KCQkJcHJpbnRmKCJDb3VsZCBub3QgcmFpc2UgU0lHQ09OVFxuIik7DQoJCQly
ZXR1cm4gUFRTX1VOUkVTT0xWRUQ7DQoJCX0NCg0KCQlpZiAod2FpdCgmaSkgPT0gLTEpIHsNCgkJ
CXBlcnJvcigiRXJyb3Igd2FpdGluZyBmb3IgY2hpbGQgdG8gZXhpdFxuIik7DQoJCQlyZXR1cm4g
UFRTX1VOUkVTT0xWRUQ7DQoJCX0NCg0KCQlpZiAoIVdJRkVYSVRFRChpKSB8fCAhV0VYSVRTVEFU
VVMoaSkpIHsNCgkJCXByaW50ZigiVGVzdCBGQUlMRURcbiIpOw0KCQkJcmV0dXJuIFBUU19GQUlM
Ow0KCQl9DQoNCgkJaWYgKGNsb2NrX2dldHRpbWUoQ0xPQ0tfUkVBTFRJTUUsICZ0c2FmdGVyKSA9
PSAtMSkgew0KCQkJcGVycm9yKCJFcnJvciBpbiBjbG9ja19nZXR0aW1lKClcbiIpOw0KCQkJcmV0
dXJuIFBUU19VTlJFU09MVkVEOw0KCQl9DQoNCgkJc2xlcHRzPXRzYWZ0ZXIudHZfc2VjLXRzYmVm
b3JlLnR2X3NlYzsNCg0KI2lmZGVmIERFQlVHDQoJCXByaW50ZigiU3RhcnQgJWQgc2VjOyBFbmQg
JWQgc2VjXG4iLCAoaW50KSB0c2JlZm9yZS50dl9zZWMsDQoJCQkJKGludCkgdHNhZnRlci50dl9z
ZWMpOw0KI2VuZGlmDQoJCWlmIChzbGVwdHMgPj0gU0xFRVBTRUMpIHsNCgkJCXByaW50ZigiVGVz
dCBQQVNTRURcbiIpOw0KCQkJcmV0dXJuIFBUU19QQVNTOw0KCQl9IGVsc2Ugew0KCQkJcHJpbnRm
KCJjbG9ja19uYW5vc2xlZXAoKSBkaWQgbm90IHNsZWVwIGxvbmcgZW5vdWdoXG4iKTsNCgkJCXJl
dHVybiBQVFNfRkFJTDsNCgkJfQ0KDQoJfSAvL2VuZCBmb3JrDQoNCglyZXR1cm4gUFRTX1VOUkVT
T0xWRUQ7DQp9DQo=
--001e680f12840162ef046c8b709c
Content-Type: application/octet-stream; name="nano_sleep_3-2.log"
Content-Disposition: attachment; filename="nano_sleep_3-2.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw236ta13

ZXhlY3ZlKCIuLzMtMi50ZXN0IiwgWyIuLzMtMi50ZXN0Il0sIFsvKiAxMCB2YXJzICovXSkgPSAw
CmJyaygwKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDB4MTEwMDAKdW5hbWUo
e3N5cz0iTGludXgiLCBub2RlPSI0My44OC4xMDEuMjExIiwgLi4ufSkgPSAwCm1tYXAyKE5VTEws
IDQwOTYsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfQU5PTllNT1VTLCAt
MSwgMCkgPSAweDQwMDFkMDAwCmFjY2VzcygiL2V0Yy9sZC5zby5wcmVsb2FkIiwgUl9PSykgICAg
ICA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKb3BlbigiL2RldmVsL2V0
Yy9sZC5zby5jYWNoZSIsIE9fUkRPTkxZKSA9IDMKZnN0YXQ2NCgzLCB7c3RfbW9kZT1TX0lGUkVH
fDA2NDQsIHN0X3NpemU9MTM5NjIsIC4uLn0pID0gMAptbWFwMihOVUxMLCAxMzk2MiwgUFJPVF9S
RUFELCBNQVBfUFJJVkFURSwgMywgMCkgPSAweDQwMDFlMDAwCmNsb3NlKDMpICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICA9IDAKb3BlbigiL2RldmVsL2xpYi9saWJwdGhyZWFkLnNvLjAi
LCBPX1JET05MWSkgPSAzCnJlYWQoMywgIlwxNzdFTEZcMVwxXDFcMFwwXDBcMFwwXDBcMFwwXDBc
M1wwKFwwXDFcMFwwXDAwMDhCXDBcMDAwNFwwXDBcMFwyMDAiLi4uLCA1MTIpID0gNTEyCmZzdGF0
NjQoMywge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTgwNTE5MCwgLi4ufSkgPSAwCm1t
YXAyKE5VTEwsIDEyNzQ3MiwgUFJPVF9SRUFEfFBST1RfRVhFQywgTUFQX1BSSVZBVEV8TUFQX0RF
TllXUklURSwgMywgMCkgPSAweDQwMDI2MDAwCm1wcm90ZWN0KDB4NDAwM2EwMDAsIDMyNzY4LCBQ
Uk9UX05PTkUpICA9IDAKbW1hcDIoMHg0MDA0MjAwMCwgODE5MiwgUFJPVF9SRUFEfFBST1RfV1JJ
VEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDE0KSA9IDB4NDAw
NDIwMDAKbW1hcDIoMHg0MDA0NDAwMCwgNDU5MiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9Q
UklWQVRFfE1BUF9GSVhFRHxNQVBfQU5PTllNT1VTLCAtMSwgMCkgPSAweDQwMDQ0MDAwCmNsb3Nl
KDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKb3BlbigiL2RldmVsL2xpYi9s
aWJydC5zby4xIiwgT19SRE9OTFkpID0gMwpyZWFkKDMsICJcMTc3RUxGXDFcMVwxXDBcMFwwXDBc
MFwwXDBcMFwwXDNcMChcMFwxXDBcMFwwXDI0MFwyNlwwXDAwMDRcMFwwXDBcNCIuLi4sIDUxMikg
PSA1MTIKZnN0YXQ2NCgzLCB7c3RfbW9kZT1TX0lGUkVHfDA3NTUsIHN0X3NpemU9MTYzNjIxLCAu
Li59KSA9IDAKbW1hcDIoTlVMTCwgNTc4NzYsIFBST1RfUkVBRHxQUk9UX0VYRUMsIE1BUF9QUklW
QVRFfE1BUF9ERU5ZV1JJVEUsIDMsIDApID0gMHg0MDA0NjAwMAptcHJvdGVjdCgweDQwMDRjMDAw
LCAyODY3MiwgUFJPVF9OT05FKSAgPSAwCm1tYXAyKDB4NDAwNTMwMDAsIDgxOTIsIFBST1RfUkVB
RHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0RFTllXUklURSwgMywgMHg1
KSA9IDB4NDAwNTMwMDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0g
MApvcGVuKCIvZGV2ZWwvbGliL2xpYm0uc28uNiIsIE9fUkRPTkxZKSAgPSAzCnJlYWQoMywgIlwx
NzdFTEZcMVwxXDFcMFwwXDBcMFwwXDBcMFwwXDBcM1wwKFwwXDFcMFwwXDBcMjYwMVwwXDAwMDRc
MFwwXDBcMzI0Ii4uLiwgNTEyKSA9IDUxMgpmc3RhdDY0KDMsIHtzdF9tb2RlPVNfSUZSRUd8MDc1
NSwgc3Rfc2l6ZT0xMzQ5MjU4LCAuLi59KSA9IDAKbW1hcDIoTlVMTCwgNjg4Mjg4LCBQUk9UX1JF
QUR8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAzLCAwKSA9IDB4NDAwNTUw
MDAKbXByb3RlY3QoMHg0MDBmNTAwMCwgMjg2NzIsIFBST1RfTk9ORSkgID0gMAptbWFwMigweDQw
MGZjMDAwLCA4MTkyLCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVE
fE1BUF9ERU5ZV1JJVEUsIDMsIDB4OWYpID0gMHg0MDBmYzAwMApjbG9zZSgzKSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgPSAwCm9wZW4oIi9kZXZlbC9saWIvbGliYy5zby42IiwgT19S
RE9OTFkpICA9IDMKcmVhZCgzLCAiXDE3N0VMRlwxXDFcMVwwXDBcMFwwXDBcMFwwXDBcMFwzXDAo
XDBcMVwwXDBcMCBSXDFcMDAwNFwwXDBcMFwyMDQiLi4uLCA1MTIpID0gNTEyCmZzdGF0NjQoMywg
e3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTc4NTUyODUsIC4uLn0pID0gMAptbWFwMihO
VUxMLCA0MDk2LCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9V
UywgLTEsIDApID0gMHg0MDAyMjAwMAptbWFwMihOVUxMLCAxMjQ5ODAwLCBQUk9UX1JFQUR8UFJP
VF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAzLCAwKSA9IDB4NDAwZmUwMDAKbXBy
b3RlY3QoMHg0MDIyMzAwMCwgMjg2NzIsIFBST1RfTk9ORSkgID0gMAptbWFwMigweDQwMjJhMDAw
LCAxMjI4OCwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBf
REVOWVdSSVRFLCAzLCAweDEyNCkgPSAweDQwMjJhMDAwCm1tYXAyKDB4NDAyMmQwMDAsIDg3MTIs
IFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0FOT05ZTU9V
UywgLTEsIDApID0gMHg0MDIyZDAwMApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgPSAwCm1tYXAyKE5VTEwsIDQwOTYsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJ
VkFURXxNQVBfQU5PTllNT1VTLCAtMSwgMCkgPSAweDQwMDIzMDAwCnNldF90bHMoMHg0MDAyMmM4
MCwgMHg0MDAyMmM4MCwgMHg2N2MsIDB4NDAwMjMzNTgsIDB4NDAwMjUwNDgpID0gMAptcHJvdGVj
dCgweDQwMjJhMDAwLCA4MTkyLCBQUk9UX1JFQUQpICAgPSAwCm1wcm90ZWN0KDB4NDAwZmMwMDAs
IDQwOTYsIFBST1RfUkVBRCkgICA9IDAKbXByb3RlY3QoMHg0MDA1MzAwMCwgNDA5NiwgUFJPVF9S
RUFEKSAgID0gMAptcHJvdGVjdCgweDQwMDQyMDAwLCA0MDk2LCBQUk9UX1JFQUQpICAgPSAwCm1w
cm90ZWN0KDB4NDAwMjQwMDAsIDQwOTYsIFBST1RfUkVBRCkgICA9IDAKbXVubWFwKDB4NDAwMWUw
MDAsIDEzOTYyKSAgICAgICAgICAgICAgID0gMApzZXRfdGlkX2FkZHJlc3MoMHg0MDAyMjgyOCkg
ICAgICAgICAgICAgPSA0NjQKc2V0X3JvYnVzdF9saXN0KDB4NDAwMjI4MzAsIDB4YykgICAgICAg
ID0gMApydF9zaWdhY3Rpb24oU0lHUlRNSU4sIHsweDQwMDJhMTI4LCBbXSwgU0FfU0lHSU5GT3ww
eDQwMDAwMDB9LCBOVUxMLCA4KSA9IDAKcnRfc2lnYWN0aW9uKFNJR1JUXzEsIHsweDQwMDI5Y2U4
LCBbXSwgU0FfUkVTVEFSVHxTQV9TSUdJTkZPfDB4NDAwMDAwMH0sIE5VTEwsIDgpID0gMApydF9z
aWdwcm9jbWFzayhTSUdfVU5CTE9DSywgW1JUTUlOIFJUXzFdLCBOVUxMLCA4KSA9IDAKZ2V0cmxp
bWl0KFJMSU1JVF9TVEFDSywge3JsaW1fY3VyPTgxOTIqMTAyNCwgcmxpbV9tYXg9UkxJTV9JTkZJ
TklUWX0pID0gMApjbG9ja19nZXR0aW1lKENMT0NLX1JFQUxUSU1FLCB7MTI0NTI0MDA0OCwgMjkx
MzEzNjA4fSkgPSAwCmNsb25lKFByb2Nlc3MgNDY1IGF0dGFjaGVkICh3YWl0aW5nIGZvciBwYXJl
bnQpClByb2Nlc3MgNDY1IHJlc3VtZWQgKHBhcmVudCA0NjQgcmVhZHkpCmNoaWxkX3N0YWNrPTAs
IGZsYWdzPUNMT05FX0NISUxEX0NMRUFSVElEfENMT05FX0NISUxEX1NFVFRJRHxTSUdDSExELCBj
aGlsZF90aWRwdHI9MHg0MDAyMjgyOCkgPSA0NjUKW3BpZCAgIDQ2NV0gbmFub3NsZWVwKHs1LCAw
fSwgIDx1bmZpbmlzaGVkIC4uLj4KW3BpZCAgIDQ2NF0gcnRfc2lncHJvY21hc2soU0lHX0JMT0NL
LCBbQ0hMRF0sIFtdLCA4KSA9IDAKW3BpZCAgIDQ2NF0gcnRfc2lnYWN0aW9uKFNJR0NITEQsIE5V
TEwsIHtTSUdfREZMLCBbXSwgMH0sIDgpID0gMApbcGlkICAgNDY0XSBydF9zaWdwcm9jbWFzayhT
SUdfU0VUTUFTSywgW10sIE5VTEwsIDgpID0gMApbcGlkICAgNDY0XSBuYW5vc2xlZXAoezEsIDB9
LCB7MSwgMH0pICAgPSAwCltwaWQgICA0NjRdIGtpbGwoNDY1LCBTSUdTVE9QIDx1bmZpbmlzaGVk
IC4uLj4KW3BpZCAgIDQ2NV0gPC4uLiBuYW5vc2xlZXAgcmVzdW1lZD4gMCkgID0gPyBFUkVTVEFS
VF9SRVNUQVJUQkxPQ0sgKFRvIGJlIHJlc3RhcnRlZCkKW3BpZCAgIDQ2NV0gLS0tIFNJR1NUT1Ag
KFN0b3BwZWQgKHNpZ25hbCkpIEAgMCAoMCkgLS0tCltwaWQgICA0NjVdIC0tLSBTSUdTVE9QIChT
dG9wcGVkIChzaWduYWwpKSBAIDAgKDApIC0tLQpbcGlkICAgNDY0XSA8Li4uIGtpbGwgcmVzdW1l
ZD4gKSAgICAgICAgPSAwCltwaWQgICA0NjRdIGtpbGwoNDY1LCBTSUdDT05UKSAgICAgICAgICA9
IDAKW3BpZCAgIDQ2NF0gd2FpdDQoLTEsIFByb2Nlc3MgNDY0IHN1c3BlbmRlZAogPHVuZmluaXNo
ZWQgLi4uPgpbcGlkICAgNDY1XSAtLS0gU0lHQ09OVCAoQ29udGludWVkKSBAIDAgKDApIC0tLQo=
--001e680f12840162ef046c8b709c--

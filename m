Return-Path: <linux-kernel-owner+w=401wt.eu-S1031475AbXEHTQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031475AbXEHTQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031388AbXEHTPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:15:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38236 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031378AbXEHTPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:15:50 -0400
Date: Tue, 8 May 2007 14:15:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>, jeffschroeder@computer.org,
       Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: [PATCH 0/2] file capabilities: Introduction
Message-ID: <20070508191548.GA29913@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are two patches which have been sitting for some time in -mm.
The first implements file capabilities, the second changes the format a
bit to accomodate potential future 64-bit capabilities.

We are hoping to get a few more eyes on the code before deciding whether
this is safe to finally push up.  There are no real objections to the
code at the moment, but the lack of serious review, especially by
filesystems experts, is somewhat worrying.  If you have some time,
please do take a look.

Appended to this email are two programs which can be used for testing.
One is the actual test program, and one is a victim who gets his file
capabilities set by, and executed by, the main test program.

Compile using
        gcc -o testfscaps testfscaps.c -lcap
        gcc -o print_caps print_caps.c -lcap

then run
        ./testfscaps 0
        ./testfscaps 1 eff
        ./testfscaps 1 perm
        ./testfscaps 1 inh
        ./testfscaps 2

Test 0 makes sure that non-root can't write file capability xattrs.
Test 1 checks various edge cases of xattr lengths and values
Test 2 checks valid xattr values and makes sure the binary with
  those values runs with the expected caps.  Compare the value which
  testfscaps says it set on print_caps with the values printed by
  print_caps.

thanks,
-serge

=================================================================
begin print_caps.c
=================================================================
/*
 * Copyright (C) IBM Corporation, 2007
 * Author: Serge Hallyn <serue@us.ibm.com>
 *
 * Prints out the capabilities with which it is running.
 */
#include <stdio.h>
#include <sys/capability.h>

int main(int argc, char *argv[])
{
	cap_t cap = cap_get_proc();

	if (!cap) {
		perror("print_caps - cap_get_proc");
		exit(1);
	}

	printf("%s: running with caps %s\n", argv[0], cap_to_text(cap, NULL));

	cap_free(cap);

	return 0;
}
=================================================================

=================================================================
begin testfscaps.c
=================================================================
/*
 * Copyright (C) IBM Corporation, 2007
 * Author: Serge Hallyn <serue@us.ibm.com>

 * Perform several tests of file capabilities:
 *  1. try setting caps without CAP_SYS_ADMIN
 *  2. try setting wrongly-sized sets of caps
 *       for eff, inh, perm, or all of the above
 *     Then run the executable
 *  3. try setting valid caps, drop rights, and run the executable,
 *     make sure we get the rights
 */
#include <stdio.h>
#include <endian.h>
#include <byteswap.h>
#include <sys/types.h>
#include <attr/xattr.h>
#include <errno.h>
#include <sys/capability.h>
int errno;

void usage(char *me)
{
	printf("Usage: %s <0|1|2> [arg]\n", me);
	printf("  0: set file caps without CAP_SYS_ADMIN\n");
	printf("  1: set bogus file caps\n");
	printf("     arg=eff: for effective caps\n");
	printf("     arg=inh: for inheritable caps\n");
	printf("     arg=perm: for permitted caps\n");
	printf("  2: test that file caps are set correctly on exec\n");
	exit(1);
}

int drop_root()
{
	int ret;
	ret = setresuid(1000, 1000, 1000);
	if (ret) {
		perror("setresuid");
		exit(4);
	}
	return 1;
}

#if BYTE_ORDER == LITTLE_ENDIAN
#define le32_to_cpu(x)  x
#define le16_to_cpu(x)  x
#define cpu_to_le32(x)  x
#define cpu_to_le16(x)  x
#else
#define le32_to_cpu(x)  bswap_32(x)
#define le16_to_cpu(x)  bswap_16(x)
#define cpu_to_le32(x)  bswap_32(x)
#define cpu_to_le16(x)  bswap_16(x)
#endif

#define TSTPATH "./print_caps"
#define CAPNAME "security.capability"
#ifndef __CAP_BITS
#define __CAP_BITS 31
#endif

int perms_test(void)
{
	int ret;
	unsigned int value[4];

	drop_root();
	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);
	value[1] = 1;
	value[2] = 1;
	value[3] = 1;
	ret = setxattr(TSTPATH, CAPNAME, value, 4*sizeof(unsigned int), 0);
	if (ret) {
		perror("setxattr");
		printf("PASS: could not set capabilities as non-root\n");
		ret = 0;
	} else {
		printf("FAIL: could set capabilities as non-root\n");
		ret = 1;
	}

	return ret;
}

static inline int getcapflag(int w)
{
	switch (w) {
		case 0: return CAP_EFFECTIVE;
		case 1: return CAP_PERMITTED;
		case 2: return CAP_INHERITABLE;
		default: exit(10);
	}
}

int fork_drop_and_exec(void)
{
	int pid = fork();
	int ret, status;

	if (ret == -1) {
		perror("pipe");
		exit(1);
	}

	if (pid < 0) {
		perror("fork");
		exit(1);
	}
	if (pid == 0) {
		drop_root();
		ret = execlp(TSTPATH, TSTPATH);
		perror("execl");
		exit(1);
	} else {
		waitpid(pid, &status, 0);
		ret = status;
	}
	return ret;
}

int run_boundary_test(char *how)
{
	int whichcap = 0;
	unsigned int value[7];
	int i, ret;

	printf("trying unused cap bits within 32 bits\n");
	if (strcmp(how, "eff") == 0)
		whichcap = 0;
	else if (strcmp(how, "perm") == 0)
		whichcap = 1;
	else if (strcmp(how, "inh") == 0)
		whichcap = 2;

	memset(value, 0, 7*sizeof(unsigned int));
	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);
	for (i=__CAP_BITS; i<sizeof(unsigned int); i++) {
		value[whichcap] = cpu_to_le32(1<<i);
		ret = setxattr(TSTPATH, CAPNAME, value, 4*sizeof(unsigned int), 0);
		if (ret)
			printf("%s test 1: error setting cap at %d %d\n",
				__FUNCTION__, whichcap, i);
		ret = fork_drop_and_exec();
		if (ret) {
			printf("%s test 1: error execing at %d %d\n",
				__FUNCTION__, whichcap, i);
		}
	}

	printf("trying cap with wrong version\n");
	memset(value, 0, 7*sizeof(unsigned int));
	value[0] = cpu_to_le32(0xFFF);
	ret = setxattr(TSTPATH, CAPNAME, value, 4*sizeof(unsigned int), 0);
	if (ret)
		printf("%s test 2: error setting cap at\n", __FUNCTION__);
	ret = fork_drop_and_exec();
	if (ret)
		printf("%s test 2: PASS (error execing)\n", __FUNCTION__);
	else
		printf("%s test 2: FAIL (succeeded execing)\n", __FUNCTION__);

	printf("trying cap which is too small\n");
	memset(value, 0, 7*sizeof(unsigned int));
	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);
	ret = setxattr(TSTPATH, CAPNAME, value, 3*sizeof(unsigned int), 0);
	if (ret)
		printf("%s test 3: error setting cap at\n", __FUNCTION__);
	ret = fork_drop_and_exec();
	if (ret)
		printf("%s test 3: PASS (error execing)\n", __FUNCTION__);
	else
		printf("%s test 3: FAIL (succeeded execing)\n", __FUNCTION__);

	printf("trying cap with 64 bits of eff, 32 each of perm and inh\n");
	memset(value, 0, 7*sizeof(unsigned int));
	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);
	ret = setxattr(TSTPATH, CAPNAME, value, 5*sizeof(unsigned int), 0);
	if (ret)
		printf("%s test 4: error setting cap at\n", __FUNCTION__);
	ret = fork_drop_and_exec();
	if (ret)
		printf("%s test 4: PASS (error execing)\n", __FUNCTION__);
	else
		printf("%s test 4: FAIL (succeeded execing)\n", __FUNCTION__);

	printf("trying full 64 bit caps, extra caps unset\n");
	memset(value, 0, 7*sizeof(unsigned int));
	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);
	ret = setxattr(TSTPATH, CAPNAME, value, 7*sizeof(unsigned int), 0);
	if (ret)
		printf("%s test 5: error setting cap at\n", __FUNCTION__);
	ret = fork_drop_and_exec();
	if (ret)
		printf("%s test 5: FAIL (error execing)\n", __FUNCTION__);
	else
		printf("%s test 5: PASS (succeeded execing)\n", __FUNCTION__);

	printf("trying full 64 bit caps, all bits set\n");
	memset(value, 0, 7*sizeof(unsigned int));
	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);
	value[1] = cpu_to_le32(-1);
	value[2] = cpu_to_le32(-1);
	value[3] = cpu_to_le32(-1);
	value[4] = cpu_to_le32(-1);
	value[5] = cpu_to_le32(-1);
	value[6] = cpu_to_le32(-1);
	ret = setxattr(TSTPATH, CAPNAME, value, 7*sizeof(unsigned int), 0);
	if (ret)
		printf("%s test 6: error setting cap at\n", __FUNCTION__);
	ret = fork_drop_and_exec();
	if (ret)
		printf("%s test 6: PASS (error execing)\n", __FUNCTION__);
	else
		printf("%s test 6: FAIL (succeeded execing)\n", __FUNCTION__);

	return 0;
}

int caps_actually_set_test(void)
{
	int whichset, whichcap, ret;
	cap_t cap;
	unsigned int value[4];
	cap_flag_t capflag;
	cap_value_t capvalue[1];

	value[0] = cpu_to_le32(_LINUX_CAPABILITY_VERSION);

	cap = cap_init();
	if (!cap) {
		perror("cap_init");
		exit(2);
	}

	for (whichset=0; whichset<3; whichset++) {
		capflag = getcapflag(whichset);
		value[1] = value[2] = value[3] = cpu_to_le32(0);
		for (whichcap=0; whichcap < __CAP_BITS; whichcap++) {
			cap_clear(cap);
			capvalue[0] = whichcap;
			cap_set_flag(cap, capflag, 1, capvalue, CAP_SET);
			value[whichset+1] = cpu_to_le32(1 << whichcap);
			ret = setxattr(TSTPATH, CAPNAME, value, 4*sizeof(unsigned int), 0);
			if (ret) {
				printf("%d %d\n", whichset, whichcap);
				perror("setxattr");
			}
			printf("execing with %s\n", cap_to_text(cap, NULL));
			ret = fork_drop_and_exec();
			if (ret) {
				printf("Error execing at %d %d\n", whichset, whichcap);
			}
		}
	}

	cap_free(cap);
	return 0;
}

int main(int argc, char *argv[])
{
	if (argc < 2)
		usage(argv[0]);

	switch(atoi(argv[1])) {
		case 0:
			return perms_test();
			break;
		case 1:
			if (argc<3)
				usage(argv[0]);
			return run_boundary_test(argv[2]);
			break;
		case 2:
			return caps_actually_set_test();
			break;
		default: usage(argv[0]);
	}
}
=================================================================

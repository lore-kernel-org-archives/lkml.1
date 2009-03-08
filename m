Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZCHEXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZCHEXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 23:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZCHEWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 23:22:54 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:59731 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCHEWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 23:22:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=FLYqR4mA2xvV+99PbWo702sjtiIYDfR82JlSYyRmdprrRngwy8RVMYyxkO8PvKgKsJ
         GEy4+dEkNojKALfaPKIXsPQ1t6zvKleeUzgJ79EWrLyGDm61OB+qhpSED5vM/g/qvvd7
         JxtvxkvnBh5wrDCLUAh/hmhkFLKbdf40Qqx90=
Message-ID: <49B3481E.5080108@gmail.com>
Date: Sun, 08 Mar 2009 05:22:54 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Observe wrapping variables in while loops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by your definition of 'if', I came up with something to test variable
wrapping in while loops, and was wondering if this was useful for the linux
kernel:

The source below is adapted to illustrate how it works. If you run it, this
will print:

 8 6 4 2 0 variable wraps at ../test.c:88:main(): -1!
...-2
 9 7 5 3 1 variable wraps at ../test.c:94:main(): -1!
...-1
 8 7 6 5 4 3 2 1 0 ...-1
 8 7 6 5 4 3 2 1 ...0
 21 22 23 24 25 26 27 28 29 30 ...31
 19 18 17 16 15 14 13 12 11 10 ...9
 4 3 2 1 0 -1 -2 -3 -4 -5 ...-6
 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 ...11
 4 2 0 variable wraps at ../test.c:129:main(): -1!
...-2

In the first two loops and the last, a wrap occurs due to the double decrement.
Tests like 'while(i++ < 30)' and 'while(j-- > -5)' are boolean.

However, this may not work for a construction like this:

while ((ret = foo())) {
	do_stuff();
}
------------------------------>8-------------8<---------------------------------
#include <stdio.h>

struct while_data {
        const char *func;
        const char *file;
        unsigned line;
        unsigned long last;
};

int is_while_wrap(struct while_data *w, unsigned long val)
{
	if (w->last < val) {
		printf("variable wraps at %s:%u:%s(): %d!\n", w->file, w->line, w->func, val);
		return 0;
	}
	w->last = val;
	return val;
}

#define __while_check__(x) ({                             \
			static struct while_data			\
                                ______w = {                             \
                                .func = __func__,                       \
                                .file = __FILE__,                       \
                                .line = __LINE__,                       \
				.last = ULONG_MAX,			\
                        };                                              \
			printf(" ");					\
                        is_while_wrap(&______w, (x)); 	\
                })

#define while(x) 	while(__while_check__(x))


int main(int argc, char* argv[])
{
	unsigned int i=9;
	while(i--) {
		printf("%d", i);
		--i;
	}
	printf("...%d\n", i);
	i=10;
	while(--i) {
		printf("%d", i);
		--i;
	}
	printf("...%d\n", i);

	i=9;
	while(i--)
		printf("%d", i);
	printf("...%d\n", i);

	i=9;
	while(--i)
		printf("%d", i);
	printf("...%d\n", i);

	i=20;
	while(i++ < 30)
		printf("%d", i);
	printf("...%d\n", i);

	i=20;
	while(i-- > 10)
		printf("%d", i);
	printf("...%d\n", i);

	int j=5;
	while(j-- > -5)
		printf("%d", j);
	printf("...%d\n", j);
	while(j++ < 10)
		printf("%d", j);
	printf("...%d\n", j);

	j=5;
	while(j--) {
		printf("%d", j);
		j--;
	}
	printf("...%d\n", j);
}

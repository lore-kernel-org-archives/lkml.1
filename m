Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZCKTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZCKTQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZCKTQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:16:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:25547 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZCKTQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cXnr3+qpi+GWgslNQMz0DnUsmk9nqPaMjUYmDR9N1B0K2IO7HDbu/ekv3lhZylxYnP
         aTC0rKMeg+Fs9zjIBspPU7EV6FNDHfFWazK2lv+z0gNJlLjEqmgdvEnHdAdix31IUnp+
         iRxFxSKRcOQXN/sylmvOJ4TXzMLHPKTyPz4GU=
Message-ID: <49B80DF6.6070407@gmail.com>
Date: Wed, 11 Mar 2009 20:16:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Observe wrapping variables in while loops
References: <49B3481E.5080108@gmail.com> <alpine.DEB.2.00.0903091119090.2203@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903091119090.2203@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> 
> On Sun, 8 Mar 2009, Roel Kluin wrote:
> 
>> Inspired by your definition of 'if', I came up with something to test variable
>> wrapping in while loops, and was wondering if this was useful for the linux
>> kernel:

> Interesting variation. Now the question is, how many bugs are we aware of 
> that were caused by wraps? If there are a few, then I would say this is 
> definitely something to look at. Otherwise, it may not be worth putting 
> this in mainline.
> 
> -- Steve

Hi Steve, Andrew,

Below is a extended version, that does some more tests. it obviously isn't
finished, it requires more work done, but I think it may eventually provide very
interesting runtime debugging observations.

Roel
------------------------------>8-------------8<---------------------------------

/* (C) Roel Kluin, 2009 GPL v.2 */

#include <stdio.h>
#include <string.h>

#define ULONG_MAX       (~0UL)
typedef enum {false, true} bool;
#define NULL ((void *)0)

struct while_data {
        const char *func;
        const char *file;
        const char *str;
        unsigned line;
	bool signd;
	bool postfix;
	bool incr;
        unsigned long last;
	bool printed;
	struct while_data *next;
};

static struct while_data *while_data_head;

int while_unsigned(struct while_data *w, int val)
{
	if (!(w->printed & 1)) {
		w->next = while_data_head;
		while_data_head = w;
		w->signd = false;

		const char* decrstr = strstr(w->str, "--");
		if (decrstr != NULL) {
			if (strcmp(decrstr, "--") == 0) {
				w->incr = false;
				w->postfix = true;
			} else if (strcmp(decrstr, w->str) == 0) {
				/* FIXME: we have to ensure that
				   the first part is a variable name
				   and nothing else */
				w->incr = false;
				w->postfix = false;
			} else {
				printf("decrement not recognized.\n");
			}
		}
		else
			printf("no decrement found.\n");
		w->printed |= 1;
	}
	if (w->last < val && !(w->printed & 2)) {
		printf("variable wraps at %s:%u:%s()!\n", w->file, w->line, w->func);
		printf("while(%s) with a variable that is %d!\n", w->str, val);
		w->printed |= 2;
		return 0;
	}
	return val;
}


int while_int(struct while_data *w, int val)
{
	if (!(w->printed & 1)) {
		w->next = while_data_head;
		while_data_head = w;
		w->signd = true;

		const char* decrstr = strstr(w->str, "--");
		if (decrstr != NULL) {
			if (strcmp(decrstr, "--") == 0) {
				w->incr = false;
				w->postfix = true;
			} else if (strcmp(decrstr, w->str) == 0) {
				/* FIXME: we have to ensure that
				   the first part is a variable name
				   and nothing else */
				w->incr = false;
				w->postfix = false;
			} else {
				printf("decrement not recognized.\n");
			}
		}
		else
			printf("no decrement found.\n");
		w->printed |= 1;
	}
	/* other test for wrapping here */
	return val;
}

#define __while_check__(x) ({						\
	static struct while_data ______w = {				\
		.func = __func__,					\
		.file = __FILE__,					\
		.str = #x,						\
		.line = __LINE__,					\
		.last = ULONG_MAX,					\
		.printed = 0,						\
	};								\
	__builtin_choose_expr(						\
		__builtin_constant_p(x),				\
		(x),							\
	__builtin_choose_expr(						\
		__builtin_types_compatible_p(typeof(x), int),		\
		while_int(&______w, (x)),				\
	__builtin_choose_expr(						\
		__builtin_types_compatible_p(typeof(x), unsigned),	\
		while_unsigned(&______w, (x)),				\
		(x)							\
	)));								\
})

#define while(x)	while(__while_check__(x))


int check_if(int val, const char* test, const char* func, int line)
{
	struct while_data *w = while_data_head;

	if (strcmp(func, while_data_head->func) != 0)
		goto end;

	/* FIXME: we have to verify that the variable
	to the left is the same as the one used in
	the while loop */
	/* TODO: also test "!= 0", "== 0" (and variants)*/
	if (w->incr ) {
		if(w->postfix) {
			if (w->signd) {
				;
			} else {
				;
			}
		} else {
			if (w->signd) {
				;
			} else {
				;
			}
		}
	} else {
		if(w->postfix) {
			if (w->signd) {
				if (strstr(test, "< 0") != 0) {
					printf("after while(%s) at %s:%u:%s()\n", w->str,
					w->file, w->line, w->func);
					printf("if(%s) at line %u is off by one.\n", test, line);
				} else if (strstr(test, ">= 0") != 0){
					printf("after while(%s) at %s:%u:%s()\n", w->str,
					w->file, w->line, w->func);
					printf("if(%s) at line %u is off by one.\n", test, line);
				}
			} else {
				if (strstr(test, "< 0") != 0) {
					printf("if(%s) at line %u is always false, since variable is unsigned.\n", test, line);
				} else if (strstr(test, ">= 0") != 0){
					printf("if(%s) at line %u is always true, since variable is unsigned.\n", test, line);
				}
			}
		} else {
			if (w->signd) {
				if (strstr(test, "<= 0") != 0) {
					printf("after while(%s) at %s:%u:%s()\n", w->str,
					w->file, w->line, w->func);
					printf("if(%s) at line %u is off by one.\n", test, line);
				} else if (strstr(test, "> 0") != 0){
					printf("after while(%s) at %s:%u:%s()\n", w->str,
					w->file, w->line, w->func);
					printf("if(%s) at line %u is off by one.\n", test, line);
				}
			} else {
				if (strstr(test, "< 0") != 0) {
					printf("if(%s) at line %u is always false, since variable is unsigned.\n", test, line);
				} else if (strstr(test, ">= 0") != 0){
					printf("if(%s) at line %u is always true, since variable is unsigned.\n", test, line);
				} else if (strstr(test, "> 0") != 0){
					printf("if(%s) at line %u is off by one.\n", test, line);
				}
			}
		}
	}
end:
	return val;
}

#define __if_check__(x) ({						\
	check_if((x), #x, __func__, __LINE__);				\
})

#define if(x)	if(__if_check__(x))

int main(int argc, char* argv[])
{
	//#define x 0
	unsigned x = 10;
	int y;
	// these alternatives, should work

	while (x--)
		/*printf("in loop:%d\n", x)*/;

	if (x < 0)
		printf("won't print!\n");

	x = 10;
	while (--x)
		/*printf("in loop:%d\n", x)*/;

	printf("after loop:%d\n", x);

	if (x < 0)
		printf("won't print!\n");

	y = 10;
	while (y--)
		/*printf("in loop:%d\n", x)*/;

	if (y < 0)
		printf("will print.\n");

	y = 10;
	while (--y)
		/*printf("in loop:%d\n", x)*/;

	if (y < 0)
		printf("won't print!\n");

	return 0;
}


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZADEKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZADEKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZADEJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:09:58 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:55094 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZADEJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hvf5t6iKcMIa4IGl1IVU8TVAWQUngdGw8YC26jHo8ROOIOZYv6DxKXAQlrezlPxIZk
         MntaGVJTLstiOoLpMiJO+2xdEhRzhizJjoSUpPTN8Wlw0NrbFDGRDtGg44XspF45YwbR
         fuxuIOiu8MlnmyeaLpPzA5hLB9BMKsNtCLB+s=
Date: Sun, 4 Jan 2009 06:10:18 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090104041018.GB5198@localhost>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <20090102205345.GB25473@Krystal> <20090102230116.GB5235@localhost> <20090102234254.GB29623@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102234254.GB29623@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 06:42:54PM -0500, Mathieu Desnoyers wrote:
> Because whatever slab_buffer_size() does will be done on the fastpath of
> the instrumented code *even when instrumentation is disabled*, and this
> is something we need to avoid above all.

I had doubts about this, so I tried it myself. It seems that when using
-O2 it generates optimal code, without computing a << b unnecessarily.
It only precomputes it at -O0. Here's how I tested...

#include <stdio.h>

#define unlikely(x)	__builtin_expect(!!(x), 0)

static int do_something_enabled;

static void print_that(unsigned long num)
{
	printf("input << 5 == %lu\n", num);
}

static inline void do_something(unsigned long num)
{
	if (unlikely(do_something_enabled)) /* Like DEFINE_TRACE does. */
		print_that(num);
}

static void call_do_something(unsigned long in)
{
	do_something(in << 5);
}

int main(int argc, char **argv)
{
	unsigned long in;

	if (argc != 3) {
		printf("Wrong number of arguments!\n");
		return 0;
	}

	sscanf(argv[1], "%d", &do_something_enabled);
	sscanf(argv[2], "%lu", &in);

	call_do_something(in);

	return 0;
}


Snippet of objdump output when using -O2:

static inline void do_something(unsigned long num)
{
	if (unlikely(do_something_enabled))
  400635:	85 c0                	test   %eax,%eax
  400637:	74 be                	je     4005f7 <main+0x17>
print_that():
/home/edi/prj/src/inlineargs/inlineargs.c:9

static int do_something_enabled;

static void print_that(unsigned long num)
{
	printf("input << 5 == %lu\n", num);
  400639:	48 c1 e6 05          	shl    $0x5,%rsi
  40063d:	bf 6e 07 40 00       	mov    $0x40076e,%edi
  400642:	31 c0                	xor    %eax,%eax
  400644:	e8 5f fe ff ff       	callq  4004a8 <printf@plt>


Snippet of objdump output when using -O0:

static void call_do_something(unsigned long in)
{
  4005fd:	55                   	push   %rbp
  4005fe:	48 89 e5             	mov    %rsp,%rbp
  400601:	48 83 ec 10          	sub    $0x10,%rsp
  400605:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
/home/edi/prj/src/inlineargs/inlineargs.c:20
	do_something(in << 5);
  400609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40060d:	48 89 c7             	mov    %rax,%rdi
  400610:	48 c1 e7 05          	shl    $0x5,%rdi
  400614:	e8 02 00 00 00       	callq  40061b <do_something>


Look at that shl, it indicates the left-shift (<< 5). In the first case it's
deferred as much as possible. However, in the second case, it's done
before calling that inline. Also confirmed with GCC using breakpoints on
that shl.

Can we take this as general behaviour, i.e. fn(a()), where fn() is inlined
and a() has no side-effects, will only compute a() when needed, at least on
GCC and when -O2 is in effect?

It only seems natural to me GCC would do this on a regular basis.


	Cheers,
	Eduard


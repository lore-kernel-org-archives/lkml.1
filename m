Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487Ab0A1SOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0A1SOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447Ab0A1SOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:14:48 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:38106 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab0A1SOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:14:47 -0500
Date: Thu, 28 Jan 2010 19:12:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Hui Zhu <hui.zhu@windriver.com>, Michal Marek <mmarek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: Re: [PATCH] markup_oops.pl: fix get "No matching code found" when
	first line of range is the faulting instruction
Message-ID: <20100128181240.GA9174@merkur.ravnborg.org>
References: <4B61357A.5080001@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61357A.5080001@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 02:58:02PM +0800, Hui Zhu wrote:
> Sorry guys, the prev mail for this patch is ugly.
> I make a new mail for it.

Random updates to scripts/* historically often go
in via the kbuild tree, so Michal added.

	Sam

[Kept rest of mail so Michal can see it]

>
> I got a "No matching code found" when I use markup_oops.pl parse a error in a x8664 module.
>
> cat e.c
> #include <linux/version.h>
> #include <linux/kernel.h>
> #include <linux/module.h>
>
>
> int init_module(void)
> {
> 	char	*buf = 0;
>
> 	buf[0] = 3;
>
> 	return 0;
> }
>
> void cleanup_module(void)
> {
> 	//char	*buf = 0;
>
> 	//buf[0] = 3;
> }
>
> MODULE_AUTHOR("Hui Zhu");
> MODULE_LICENSE("GPL");
>
>
> 0000000000000000 <init_module>:
> init_module():
> /home/teawater/study/kernel/stack2core/example/e.c:10
>   0:	c6 04 25 00 00 00 00 	movb   $0x3,0x0
>   7:	03 /home/teawater/study/kernel/stack2core/example/e.c:13
>   8:	31 c0                	xor    %eax,%eax
>   a:	c3                   	retq     b:	0f 1f 44 00 00       	nopl   
> 0x0(%rax,%rax,1)
>
> 0000000000000010 <cleanup_module>:
> cleanup_module():
> /home/teawater/study/kernel/stack2core/example/e.c:20
>  10:	f3 c3                	repz retq  12:	90                   	nop     
> 13:	90                   	nop    Disassembly of section .modinfo:
>
> This is because the faulting instruction "movb   $0x3,0x0" is the first line of the range.
>
> In the markup_oops.pl:
> main::(./scripts/markup_oops.pl:245):
> 245:				if (InRange($1, $target)) {
>  DB<2> p $line
> ffffffffa001b000:	c6 04 25 00 00 00 00 	movb   $0x3,0x0
>  DB<3> p $counter
> 0
>
> It just set $center in next loop.
> So it cannot get the $center.
>
> And even if $center is set to the right value 0.
> if ($center == 0) {
> 	print "No matching code found \n";
> 	exit;
> }
>
> So I make a patch change this part to:
> 	}
> 	if ($state == 1) {
> And this is another part is not OK too:
> if ($center == 0) {
> The first line $center will be 0, so I change the default value and decide to:
> my $center  = -1;
> if ($center == -1) {
>
> Thanks,
> Hui
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
>
> ---
> scripts/markup_oops.pl |    7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -214,7 +214,7 @@ if ($module ne "") {
>
> my $counter = 0;
> my $state   = 0;
> -my $center  = 0;
> +my $center  = -1;
> my @lines;
> my @reglines;
>
> @@ -246,7 +246,8 @@ while (<FILE>) {
> 				$state = 1;
> 			}
> 		}
> -	} else {
> +	}
> +	if ($state == 1) {
> 		if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
> 			my $val = $1;
> 			if (!InRange($val, $target)) {
> @@ -269,7 +270,7 @@ if ($counter == 0) {
> 	exit;
> }
>
> -if ($center == 0) {
> +if ($center == -1) {
> 	print "No matching code found \n";
> 	exit;
> }
>

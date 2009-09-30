Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZI3RqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZI3RqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZI3RqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:46:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53805 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZI3RqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:46:21 -0400
Date: Wed, 30 Sep 2009 18:46:24 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] checkpatch: fix __attribute__ matching
Message-ID: <20090930174624.GF2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 07:14:50PM -0700, Daniel Walker wrote:
> In the following code,
> 
> union thread_union init_thread_union
> 	__attribute__((__section__(".data.init_task"))) =
> 		{ INIT_THREAD_INFO(init_task) };
> 
> There is a non-conforming declaration. It should really be like the
> following,
> 
> union thread_union init_thread_union
> 	__attribute__((__section__(".data.init_task"))) = {
> 		INIT_THREAD_INFO(init_task)
> };
> 
> However, checkpatch doesn't catch this right now because it doesn't
> correctly evaluate the "__attribute__". I just fixed it to pattern
> match the attribute in the case above.
> 
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> ---
>  scripts/checkpatch.pl |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index c7f741f..fd4fe03 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -134,7 +134,7 @@ our $Attribute	= qr{
>  			____cacheline_aligned|
>  			____cacheline_aligned_in_smp|
>  			____cacheline_internodealigned_in_smp|
> -			__weak
> +			__weak|(?:__attribute__\(.*\))

The problem with the __attribute__ match is that it is impossible to
sensibly write as a regular-expression as it has nested round brackets
within it.  I do wonder why we care what is before the equals.  I
suspect that any assignment ='s followed by a newline, followed by a {
is wrong.  There are few places that a { is right on the next line.

I'll try that one out and see if it fires any false positives.  Its
passing my tests here.

Could you see if the version at the url below works better for you:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

NOTE: you want at least version 0.29-5-* which is in the process of 
mirroring out.

-apw

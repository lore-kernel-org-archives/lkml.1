Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYBKQ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYBKQ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYBKQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:58:27 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:49525 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbYBKQ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:58:25 -0500
Message-ID: <47B07EA0.7010708@panasas.com>
Date: Mon, 11 Feb 2008 18:58:08 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
References: <20080210143240.GA13317@joi> <20080211102339.GD11671@shadowen.org> <47B0725C.30407@panasas.com> <20080211164046.GI11671@shadowen.org>
In-Reply-To: <20080211164046.GI11671@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 11, 2008, 18:40 +0200, Andy Whitcroft <apw@shadowen.org> wrote:
> On Mon, Feb 11, 2008 at 06:05:48PM +0200, Benny Halevy wrote:
>> I saw this too with checkpatch.pl version 0.12
>> It seems like checkpatch.pl knows only about types derived
>> from @typeList by build_types.
>>
>> Example below...
>>
>> Benny
>>
>> $ cat <<EOF | scripts/checkpatch.pl -
>> Signed-off-by: john@smith.net
>> ---
>> diff a/f.c b/f.c
>> --- a/f.c
>> +++ b/f.c
>> @@ -1,0 +1,2 @@
>> +foo(int a, my_uint32 *);
>> +bar(int a, my_uint32_t *);
> 
> But that isn't actually syntactically correct code is it?  You have types
> as parameters like a function declaration, but no return type.  So there
> is no hint to checkpatch that this is a function declaration and therefore
> the parameters are not expected to be types, nor are they checked as such.
> 
> The following diff is clean on the latest version of checkpatch:
> 
> Signed-off-by: john@smith.net
> ---
> diff a/f.c b/f.c
> --- a/f.c
> +++ b/f.c
> @@ -1,0 +1,2 @@
> +void foo(int a, my_uint32 *);
> +int bar(int a, my_uint32_t *);
> EOF

OK, but the return type doesn't have to be in the patched line, it could be in
a synchronization line or even missing if the function has a long multi-line argument
list.

> 
> Could you try out the version of checkpatch at the URL below on the real
> patch you are using to test, and let me know if it works.  There are
> a number of improvements to type tracking in the face of ifdef's and
> the like.  If it doesn't could I have the hunk which fails:
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-next

Your modified patch passes with version 0.12 as well as checkpatch.pl-next

However, the following patch that has the return type in the synchronization lines
still produces the same error:

$ ./checkpatch.pl-next -
Signed-off-by: john@smith.net
---
diff a/f.c b/f.c
--- a/f.c
+++ b/f.c
@@ -1,2 +1,4 @@
 int
+foo(int a, my_uint32 *);
 int
+bar(int a, my_uint32_t *);
ERROR: need consistent spacing around '*' (ctx:WxB)
#8: FILE: f.c:2:
+foo(int a, my_uint32 *);
                      ^

total: 1 errors, 0 warnings, 4 lines checked

> 
> -apw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


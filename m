Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbZLRUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbZLRUM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbZLRUMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:12:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbZLRUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:12:23 -0500
Message-ID: <4B2BE1BF.60803@zytor.com>
Date: Fri, 18 Dec 2009 12:10:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: move range related operation to one file
References: <4B2B4C19.6010402@kernel.org> <4B2B4F85.5030901@kernel.org>
In-Reply-To: <4B2B4F85.5030901@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 01:46 AM, Yinghai Lu wrote:
> +
> +struct range {
> +	u64   start;
> +	u64   end;
> +};

Okay, this does bring up two things that I have long griped about.

Firstly, I don't think this is the proper data structure.  Even worse,
the range operations take *inclusive* ranges (e.g. 0x0000 to 0xffff is
64K, not 0x0000 to 0x10000).  It would be one thing if it only affected
the internal representation, but as written, this is exposed through the
interfaces, too.

As far as the choice of data structures, I have used in other places,
with very good success, a data structure which looks like:

struct {
	u64	start;
	u32	attr;
};

Note that there is no end: the end is always given by an end token.  The
"attr" here was an e820 attribute (or 0 for no attribute), but the
payload can be almost anything -- for a simple include/exclude it can
just be boolean.

This data structures doesn't permit things like out-of-order ranges,
overlapping ranges, and so on, and that's a good thing; it means the
data structure itself can never be ambiguous, and the interfaces clean
out most errors inherently.

http://git.kernel.org/?p=boot/syslinux/syslinux.git;a=blob;f=com32/lib/syslinux/zonelist.c;hb=HEAD

... contains an implementation of this data structure using linked lists
for internal storage, and

http://git.kernel.org/?p=boot/syslinux/syslinux.git;a=blob;f=memdisk/e820func.c;hb=HEAD

... contains one based on arrays.  I'm not saying these should be
applied directly, but I think the equivalent concept might be
worthwhile, not just for this but also for the e820 memrange code.

	-hpa

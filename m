Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbXINBDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbXINBDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbXINBDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:03:37 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63837 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbXINBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:03:36 -0400
Message-ID: <46E9DDC1.2060401@ak.jp.nec.com>
Date: Fri, 14 Sep 2007 10:02:57 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       selinux@tycho.nsa.gov, Yuichi Nakamura <ynakam@hitachisoft.jp>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Wrappers to load bitmaps (Re: [PATCH] Improve ebitmap scanning)
References: <20070821130540.7AD3.YNAKAM@hitachisoft.jp>	 <46CC00F4.2090501@ak.jp.nec.com> <46E7583C.9030103@ak.jp.nec.com>	 <200709121554.41662.paul.moore@hp.com>  <46E8945A.9090603@ak.jp.nec.com> <1189683270.13723.5.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1189683270.13723.5.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now I'm improving the performance to scan bitmap in SELinux,
with replacing its original bitmap implementation (ebitmap)
by common bitops like find_next_bit().

I posted a patch to replace them, however, it got a bit complex
bacause we had to translate u64 <--> unsigned long by myself
to adjust between the format of security policy and common bitops.
  http://marc.info/?l=selinux&m=118956715414494&w=2

I have an idea to provide several wrapper functions to copy u64/u32
to/from unsigned long for each architecture.
Maybe, it will be defined as follows:
  int arraycpy_u64_to_ulong(u64 *src, unsigned long *dest, size_t len);
  int arraycpy_ulong_to_u64(unsigned long *src, u64 *dest, size_t len);

I believe this feature will help getting code simpler and reducing bugs
for any other subsystem, not only SELinux, which loads bitmaps from/to
userspace and handle them using common bitops.

Any comment please.

Stephen Smalley wrote:
> On Thu, 2007-09-13 at 10:37 +0900, KaiGai Kohei wrote:
>> Paul Moore wrote:
>>> On Tuesday, September 11 2007 11:08:44 pm KaiGai Kohei wrote:
>>>> The attached patch applies the standard bitmap operations
>>>> for the iteration macro of ebitmap, and enables to improve
>>>> the performance in AVC-misses case.

  <...snip...>

>> BTW, is there any wrapper to copy an array of u64 to/from architecture specific
>> unsigned long? If so, it will help implement ebitmap_netlbl_{import|export}()
>> and ebitmap_read() more simply.
> 
> Might want to ask on linux-kernel.  More generally, it might be a good
> idea to cc linux-kernel on your next posting of the patch to get wider
> review of how you are using the native linux bitmap support.
> 
> The patch looks very promising, although a detailed review and testing
> might take a little bit.

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>

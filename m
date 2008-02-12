Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbYBLIef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbYBLIef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYBLIe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:34:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbYBLIeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:34:25 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages()
To: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Reply-To: 7eggert@gmx.de
Date: Tue, 12 Feb 2008 09:34:16 +0100
References: <9VQ6w-5Xn-7@gated-at.bofh.it> <9VY4a-1tI-21@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JOqan-0000hX-1T@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/EsY4HO46HBQR8iAz6jKZgHr5qHtLUNs5HzdO
 dt91rlI5n7lcFw/2ZFilW96reGQtRXOEeo091NN6lhpSeNVxh3
 szWbkIDuuehN4ew0rxa4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 11 Feb 2008 16:17:33 -0700 Jonathan Corbet <corbet@lwn.net> wrote:

>> Avoid buffer overflows in get_user_pages()
>> 
>> So I spent a while pounding my head against my monitor trying to figure
>> out the vmsplice() vulnerability - how could a failure to check for
>> *read* access turn into a root exploit?  It turns out that it's a buffer
>> overflow problem which is made easy by the way get_user_pages() is
>> coded.
>> 
>> In particular, "len" is a signed int, and it is only checked at the
>> *end* of a do {} while() loop.  So, if it is passed in as zero, the loop
>> will execute once and decrement len to -1.  At that point, the loop will
>> proceed until the next invalid address is found; in the process, it will
>> likely overflow the pages array passed in to get_user_pages().

[...]

> Can we just convert
> 
> do {
> ...
> } while (len);
> 
> into
> 
> while (len) {

while (len > 0), if I understand this patch correctly.


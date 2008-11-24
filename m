Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYKXO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYKXO23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKXO2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:28:20 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:14149 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYKXO2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AoJIWwlIM93FmWtCQ3SQNVdkHU53fA+kHyQ9NkXfRCdeY3Hm0WJXRJhh8KxgSqI17o
         QfGh2iUxpSjJtdBkE34CYdCKXPCu7lLnZvzrvVO0HeGqh9y9+/rafog34xwxsQnNek2B
         nLV0Wbsy8coW4qjjVcaAZazCe8r12AAy6FroQ=
Message-ID: <492AB9FD.5010602@gmail.com>
Date: Mon, 24 Nov 2008 16:28:13 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: James.Bottomley@HansenPartnership.com
CC: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc6-tip fails to build with gcc 4.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using gcc version 4.4.0 20081120 (experimental) [trunk revision 142055]
I can't build latest tip/master (commit
b27fef5b222564b6e7ae71f7110c233b2fb45a38)

drivers/built-in.o: In function `sd_revalidate_disk':
sd.c:(.text+0x8bc76): undefined reference to `____ilog2_NaN'
make: *** [.tmp_vmlinux1] Error 1

Apparently gcc determines that sector_size can have an invalid constant
value as ilog2's parameter in sd_read_capacity.

I tried to narrow down, but all I found so far is that gcc 4.4.0 now
says that __builtin_constant_p() is true even in these cases:

a = .. constant value ...
if (cond) {
     a = ... constant value ...
}
__builtin_constant_p(a) ? ....

a = .. constant value ...
if (cond) {
     a = ... constant value ...
} else {
   a = ... another constant value ...
}
__builtin_constant_p(a) ? ....

I guess it clones the __builtin_constant_p for each branch, where a is
constant, gcc 4.3 doesn't seem to do that.

Did it find a real bug in sd.c, or is it a gcc bug?

Best regards,
--Edwin

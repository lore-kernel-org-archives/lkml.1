Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYCNOv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYCNOv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYCNOvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:51:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:47118 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYCNOvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j7aMVdHDG6hdovzZUKHnyC1KP6J1vVSl7S+WKz5+RwNQ8JHwZoRhlySNjo86KuqfgBfxoItAEGWBM8OBZhDFjoWRu52EKlJgYuqOWBiZVUtJZDftJ+TZMpD72KdXv3rC+5UY2uIJPkHI2LeX5b3MSqL6bDXahFBc6SJIi/jXZyo=
Message-ID: <54b90fdf0803140751m71935a09r9b039ca6eb124f4d@mail.gmail.com>
Date: Fri, 14 Mar 2008 10:51:43 -0400
From: Yan <rottled@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22.6 - Discrepancy between running and on-disk kernels
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been trying to compare the code from the on-disk compressed kernel
that was booted and the running kernel extracted from /dev/kmem. I extracted
the kernel's code from the disk image by stripping the head.S and similar
and gunzipping it, and extracted the kernel from /dev/kmem by reading data
between _text and _etext symbol offsets.

I then ran both through a disassembler and diff'ed the outputs. Predictably,
the disassembly was similar, but not identical. Some instructions (e.g. bts)
had a 'lock' prefix, where as others had a 'nop' in its place.

There were other differences with some instructions like mfence. Everything
else matched just fine, the differences were mostly in memory-referencing
instructions.

My question is, what can be changing the kernel between being on static
storage and being loaded? Or am I just being fooled into thinking something
changed it? I'm thinking that it had something to do with mutex locking
and SMP, but I looked through boot code and tried googling and came up with
nothing. Another possibility is me interpreting non-instructions as
instructions.

Example:

The following pattern repeats a lot:

1325c1326,1327
<     1089: f0 0f b3 04 24          lock btr %eax,(%esp)
---
>     1089: 90                      nop
>     108a: 0f b3 04 24             btr    %eax,(%esp)

As well as other changes:

94383,94384c94832,94835
<    47bb3: f0 83 04 24 00          lock addl $0x0,(%esp)
<    47bb8: f0 ff 05 7c 30 80 c0    lock incl 0xc080307c
---
>    47bb3: 0f ae f0                mfence
>    47bb6: 89 f6                   mov    %esi,%esi
>    47bb8: 90                      nop
>    47bb9: ff 05 7c 30 80 c0       incl   0xc080307c


(I'm not subscribed; please cc any responses to me)

Thanks in advance,
Yan

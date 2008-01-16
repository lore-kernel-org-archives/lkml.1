Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYAPLED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYAPLED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYAPLDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:03:52 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:37221 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYAPLDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:03:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=kdYK/lkyqPtHtoAjgvl3vvz+TiUJfXFhhbtfBL3ztxZFa40SBI0HfZhxGCGzD0/lnETkTNSiobrTOdujgcePycbH1dV2fgCZGCGO7yLoQXqYD9O7WR2CU6N27frD4XMsxkOL3Ead9ompbVf/QCgE2M53YyqWC3HJhez1t5Avb3k=
Message-ID: <cfd9edbf0801160303s53237b81yb9d5e374c16cd006@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:03:49 +0100
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Cc: "Rik van Riel" <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080116104536.11AE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_23898_28428135.1200481429593"
References: <20080115175925.215471e1@bree.surriel.com>
	 <cfd9edbf0801151539g72ca9777h7ac43a31aadc730e@mail.gmail.com>
	 <20080116104536.11AE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_23898_28428135.1200481429593
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 1/16/08, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Daniel
>
> > > > The notification fires after only ~100 MB allocated, i.e., when page
> > > > reclaim is beginning to nag from page cache. Isn't this a bit early?
> > > > Repeating the test with swap enabled results in a notification after
> > > > ~600 MB allocated, which is more reasonable and just before the system
> > > > starts to swap.
> > >
> > > Your issue may have more to do with the fact that the
> > > highmem zone is 128MB in size and some balancing issues
> > > between __alloc_pages and try_to_free_pages.
> >
> > I don't think so. I ran the test again without highmem and noticed the
> > same behaviour:
>
> Thank you for good point out!
> Could you please post your test program and reproduced method?

Sure:

1. Fill almost all available memory with page cache in a system without swap.
2. Run attached alloc-test program.
3. Notification fires when page cache is reclaimed.

Example:

$ cat /bigfile > /dev/null
$ cat /proc/meminfo
MemTotal:       895876 kB
MemFree:         94272 kB
Buffers:           884 kB
Cached:         782868 kB
SwapCached:          0 kB
Active:          15356 kB
Inactive:       778000 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       895876 kB
LowFree:         94272 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:           0 kB
AnonPages:        9624 kB
Mapped:           1352 kB
Slab:             4220 kB
SReclaimable:     1168 kB
SUnreclaim:       3052 kB
PageTables:        528 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    447936 kB
Committed_AS:    28988 kB
VmallocTotal:   122872 kB
VmallocUsed:       904 kB
VmallocChunk:   121864 kB
$ ./test-alloc
---------
Got notification, allocated 90 MB
$ cat /proc/meminfo
MemTotal:       895876 kB
MemFree:        101960 kB
Buffers:           888 kB
Cached:         775200 kB
SwapCached:          0 kB
Active:          15356 kB
Inactive:       770336 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       895876 kB
LowFree:        101960 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              28 kB
Writeback:           0 kB
AnonPages:        9624 kB
Mapped:           1352 kB
Slab:             4224 kB
SReclaimable:     1168 kB
SUnreclaim:       3056 kB
PageTables:        532 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    447936 kB
Committed_AS:    28988 kB
VmallocTotal:   122872 kB
VmallocUsed:       904 kB
VmallocChunk:   121864 kB

------=_Part_23898_28428135.1200481429593
Content-Type: application/octet-stream; name=alloc-test.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fbhrli8a
Content-Disposition: attachment; filename=alloc-test.c

LyoKICogQWxsb2NhdGUgMTAgTUIgZWFjaCBzZWNvbmQuIEV4aXQgb24gbm90aWZpY2F0aW9uLgog
Ki8KCiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0
ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8
c3RyaW5nLmg+CiNpbmNsdWRlIDxwb2xsLmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRl
IDxlcnJuby5oPgoKaW50IGNvdW50ID0gMDsKaW50IHNpemUgPSAxMDsKCnZvaWQgKmRvX2FsbG9j
KCkgCnsKICAgICAgICBmb3IoOzspIHsKICAgICAgICAgICAgICAgIGludCAqYnVmZmVyOwogICAg
ICAgICAgICAgICAgYnVmZmVyID0gbW1hcChOVUxMLCAgc2l6ZSoxMDI0KjEwMjQsCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFBST1RfUkVBRCB8IFBST1RfV1JJVEUsCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwog
ICAgICAgICAgICAgICAgaWYgKGJ1ZmZlciA9PSBNQVBfRkFJTEVEKSB7CiAgICAgICAgICAgICAg
ICAgICAgICAgIHBlcnJvcigibW1hcCIpOwogICAgICAgICAgICAgICAgICAgICAgICBleGl0KEVY
SVRfRkFJTFVSRSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBtZW1zZXQoYnVm
ZmVyLCAxICwgc2l6ZSoxMDI0KjEwMjQpOwoKICAgICAgICAgICAgICAgIHByaW50ZigiLSIpOwog
ICAgICAgICAgICAgICAgZmZsdXNoKHN0ZG91dCk7CgogICAgICAgICAgICAgICAgY291bnQrKzsK
ICAgICAgICAgICAgICAgIHNsZWVwKDEpOwogICAgICAgIH0KfQoKaW50IHdhaXRfZm9yX25vdGlm
aWNhdGlvbihzdHJ1Y3QgcG9sbGZkICpwZmQpCnsKICAgICAgICBpbnQgcmV0OwogICAgICAgIHJl
YWQocGZkLT5mZCwgMCwgMCk7CiAgICAgICAgcmV0ID0gcG9sbChwZmQsIDEsIC0xKTsKICAgICAg
ICBpZiAocmV0ID09IC0xICYmIGVycm5vICE9IEVJTlRSKSB7CiAgICAgICAgICAgICAgICBwZXJy
b3IoInBvbGwiKTsKICAgICAgICAgICAgICAgIGV4aXQoRVhJVF9GQUlMVVJFKTsKICAgICAgICB9
CiAgICAgICAgcmV0dXJuIHJldDsKfQoKdm9pZCBkb19mcmVlKCkgCnsKICAgICAgICBzdHJ1Y3Qg
cG9sbGZkIHBmZDsKCiAgICAgICAgcGZkLmZkID0gb3BlbigiL2Rldi9tZW1fbm90aWZ5IiwgT19S
RE9OTFkpOwogICAgICAgIGlmIChwZmQuZmQgPT0gLTEpIHsKICAgICAgICAgICAgICAgIHBlcnJv
cigib3BlbiIpOwogICAgICAgICAgICAgICAgZXhpdChFWElUX0ZBSUxVUkUpOwogICAgICAgIH0K
ICAgICAgICBwZmQuZXZlbnRzID0gUE9MTElOOwogICAgICAgIGZvcig7OykKICAgICAgICAgICAg
ICAgIGlmICh3YWl0X2Zvcl9ub3RpZmljYXRpb24oJnBmZCkgPiAwKSB7CiAgICAgICAgICAgICAg
ICAgICAgICAgIHByaW50ZigiXG5Hb3Qgbm90aWZpY2F0aW9uLCBhbGxvY2F0ZWQgJWQgTUJcbiIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzaXplICogY291bnQpOwogICAgICAgICAg
ICAgICAgICAgICAgICBleGl0KEVYSVRfU1VDQ0VTUyk7CiAgICAgICAgICAgICAgICB9Cn0KCmlu
dCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCnsKICAgICAgICBwdGhyZWFkX3QgYWxsb2Nh
dG9yOwoKICAgICAgICBwdGhyZWFkX2NyZWF0ZSgmYWxsb2NhdG9yLCBOVUxMLCBkb19hbGxvYywg
TlVMTCk7CiAgICAgICAgZG9fZnJlZSgpOwp9Cg==
------=_Part_23898_28428135.1200481429593--

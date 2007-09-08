Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXIHHvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXIHHvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXIHHu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:50:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:35699 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXIHHu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=fsYZc4hn9LyIOUBeLsqN/XLl5phVCSbhwSTWXJho6ddWyvpD1CGzGP3SK6vzCxbFDchi96PhvtxpmOh133xK2CPwd4n/BGHB39z2khKLqlrtdr7hx5QUYSf+//ddH+tC3gBxazV90bFUjKVjSusZkYR2FSNhF06yGPIJEpw8Wwo=
Message-ID: <a781481a0709080050g746718a7y3c808c2d4f3c4e73@mail.gmail.com>
Date: Sat, 8 Sep 2007 13:20:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc4-mm1 build issue: ia64 link error
Cc: "Luck, Tony" <tony.luck@intel.com>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0709080035h3df2c664x6586ca09c727a096@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5848_3338988.1189237855873"
References: <20070906183546.GA1449@Krystal>
	 <617E1C2C70743745A92448908E030B2A025B103D@scsmsx411.amr.corp.intel.com>
	 <20070907040104.fad5fc70.akpm@linux-foundation.org>
	 <a781481a0709080035h3df2c664x6586ca09c727a096@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5848_3338988.1189237855873
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 9/8/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 9/7/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Fri, 7 Sep 2007 00:34:59 -0700 "Luck, Tony" <tony.luck@intel.com> wrote:
> > > > local symbol 0: discarded in section `.exit.text' from arch/ia64/kernel/built-in.o
> > >
> > > This usually means that there is a static __exit function (or __devexit etc.)
> > > somewhere in the object being linked.  The error message is pretty unhelpful
> > > in figuring out *where* in the module.  Look at the 'mm' patches that touch
> > > arch/ia64/kernel to see if one of them tinkers with __exit* attributes.
> >
> > Confused.  There are >2500 static __exit functions in the tree, including
> > ones like
> >
> > arch/ia64/kernel/esi.c:static void __exit esi_exit (void)
>
> That message means the linker found someone referencing an .exit.text
> function -- on other archs this would've been a section mismatch but on
> ia64 its a link error due to reasons below
> (although it would not have ever caused an oops).
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In general, there's obviously nothing wrong with ia64's policy of discarding
.exit.text at link time (in fact it's a good optimization), and generally most
references from .init.text (or .text) to .exit.text would really be oopsen.

But not so with this case, because with HOTPLUG_CPU=n (which is when
this link error can occur) it's not possible for the notifier to be
called out in
the first place, and especially not for a CPU_DEAD event, which is when
this reference could've occurred in practice.

Anyway, I came across another little thing while investigating this, patch
attached ...


Satyam

------=_Part_5848_3338988.1189237855873
Content-Type: text/x-diff; name="ia64-perfmon-remove-exit_pfm_fs.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ia64-perfmon-remove-exit_pfm_fs.patch"
X-Attachment-Id: f_f6btpzud

W1BBVENIXSBpYTY0IHBlcmZtb246IFJlbW92ZSBleGl0X3BmbV9mcygpCgpCZWNhdXNlIGl0IGlz
IGRlYWQgY29kZSBhbmQgbm90IHJlZmVyZW5jZWQgYnkgYW55Ym9keSBlbHNlICh0aGF0IGZpbGUK
Y2Fubm90IGJlIGJ1aWx0IG1vZHVsYXIpLgoKU2lnbmVkLW9mZi1ieTogU2F0eWFtIFNoYXJtYSA8
c2F0eWFtQGluZnJhZGVhZC5vcmc+CgotLS0KCiBhcmNoL2lhNjQva2VybmVsL3BlcmZtb24uYyB8
ICAgIDcgLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDcgZGVsZXRpb25zKC0pCgotLS0gbGludXgt
Mi42LjIzLXJjNC1tbTEvYXJjaC9pYTY0L2tlcm5lbC9wZXJmbW9uLmN+Zml4CTIwMDctMDktMDgg
MTI6NTQ6MjQuMDAwMDAwMDAwICswNTMwCisrKyBsaW51eC0yLjYuMjMtcmM0LW1tMS9hcmNoL2lh
NjQva2VybmVsL3BlcmZtb24uYwkyMDA3LTA5LTA4IDEyOjU0OjU2LjAwMDAwMDAwMCArMDUzMApA
QCAtMTUzOSwxMyArMTUzOSw2IEBAIGluaXRfcGZtX2ZzKHZvaWQpCiAJcmV0dXJuIGVycjsKIH0K
IAotc3RhdGljIHZvaWQgX19leGl0Ci1leGl0X3BmbV9mcyh2b2lkKQotewotCXVucmVnaXN0ZXJf
ZmlsZXN5c3RlbSgmcGZtX2ZzX3R5cGUpOwotCW1udHB1dChwZm1mc19tbnQpOwotfQotCiBzdGF0
aWMgc3NpemVfdAogcGZtX3JlYWQoc3RydWN0IGZpbGUgKmZpbHAsIGNoYXIgX191c2VyICpidWYs
IHNpemVfdCBzaXplLCBsb2ZmX3QgKnBwb3MpCiB7Cg==
------=_Part_5848_3338988.1189237855873--

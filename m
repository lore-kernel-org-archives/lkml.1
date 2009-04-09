Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbZDIOHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbZDIOHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZDIOHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:07:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53669 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbZDIOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W5HSKjAjQOhPSJISml9DvtpAtXTXgCX/Tfu6E44DPRyjqAJfclRjZ77t51+/Nr2B6Z
         1UUoFi+akrYJO+46JPYq97bCc1RB1MVYfDnMNW2gpcPuBs53f/Gd59qG5nLWOKnCpkTt
         Ed/Ssi8aMnP/4+cyLmfpfAttQgSXsB8RAGJQ8=
MIME-Version: 1.0
In-Reply-To: <200903301936.08477.cova@ferrara.linux.it>
References: <200903301936.08477.cova@ferrara.linux.it>
Date: Thu, 9 Apr 2009 16:07:40 +0200
Message-ID: <19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
Subject: Re: [BUG] spinlock lockup on CPU#0
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Fabio Coatti <cova@ferrara.linux.it>
Cc: Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c5b0546b679804671fc55a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5b0546b679804671fc55a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2009/3/30 Fabio Coatti <cova@ferrara.linux.it>:
> Hi all, I've got the following BUG: report on one of our servers running
> 2.6.28.8; some background:
> we are seeing several lockups in db (mysql) servers that shows up as a su=
dden
> load increase and then, very quickly, the server freezes. It happens in a
> random way, sometimes after weeks, sometimes very quickly after a system
> reboot. Trying to discover the problem we installed latest (at the time o=
f
> test) 2.6.28.X kernel and loaded it with some high disk I/O operations (f=
ind,
> dd, rsync and so on).
> We have been able =C2=A0to crash a server with these tests; unfortunately=
 we have
> been able to capture only a remote screen snapshot so I copied by hand
> (hopefully without typos) the data and this is the result is the followin=
g:

Hi,

Thanks for the report.

>
> =C2=A0[<ffffffff80213590>] ? default_idle+0x30/0x50
> =C2=A0[<ffffffff8021358e>] ? default_idle+0x2e/0x50
> =C2=A0[<ffffffff80213793>] ? c1e_idle+0x73/0x120
> =C2=A0[<ffffffff80259f11>] ? atomic_notifier_call_chain+0x11/0x20
> =C2=A0[<ffffffff8020a31f>] ? cpu_idle+0x3f/0x70
> BUG: spinlock lockup on CPU#0, find/13114, ffff8801363d2c80
> Pid: 13114, comm: find Tainted: G =C2=A0 =C2=A0 =C2=A0D W =C2=A02.6.28.8 =
#5
> Call Trace:
> =C2=A0[<ffffffff8041a02e>] _raw_spin_lock+0x14e/0x180
> =C2=A0[<ffffffff8060b691>] _spin_lock+0x51/0x70
> =C2=A0[<ffffffff80231ca4>] ? task_rq_lock+0x54/0xa0
> =C2=A0[<ffffffff80231ca4>] task_rq_lock+0x54/0xa0
> =C2=A0[<ffffffff80234501>] try_to_wake_up+0x91/0x280
> =C2=A0[<ffffffff80234720>] wake_up_process+0x10/0x20
> =C2=A0[<ffffffff803bf863>] xfsbufd_wakeup+0x53/0x70
> =C2=A0[<ffffffff802871e0>] shrink_slab+0x90/0x180
> =C2=A0[<ffffffff80287526>] try_to_free_pages+0x256/0x3a0
> =C2=A0[<ffffffff80285280>] ? isolate_pages_global+0x0/0x280
> =C2=A0[<ffffffff80281166>] __alloc_pages_internal+0x1b6/0x460
> =C2=A0[<ffffffff802a186d>] alloc_page_vma+0x6d/0x110
> =C2=A0[<ffffffff8028d3ab>] handle_mm_fault+0x4ab/0x790
> =C2=A0[<ffffffff80225293>] do_page_fault+0x463/0x870
> =C2=A0[<ffffffff8060b199>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> =C2=A0[<ffffffff8060bf52>] error_exit+0x0/0xa9

Seems like you hit this:

/*
 * This could deadlock.
 *
 * But until all the XFS lowlevel code is revamped to
 * handle buffer allocation failures we can't do much.
 */
if (!(++retries % 100))
        printk(KERN_ERR
                        "XFS: possible memory allocation "
                        "deadlock in %s (mode:0x%x)\n",
                        __func__, gfp_mask);

XFS_STATS_INC(xb_page_retries);
xfsbufd_wakeup(0, gfp_mask);
congestion_wait(WRITE, HZ/50);
goto retry;

...so my guess is that you ran out of memory (and XFS simply can't
handle it -- an error in the XFS code, of course).

My first tip, if you simply want your servers not to crash, is to
switch to another filesystem. You could at least try it and see if it
helps your problem -- that's the most straight-forward solution I can
think of.

>
> The machine is a dual 2216HE (2 cores) AMD with 4 Gb ram; below you can f=
ind
> the .config file. (from /proc/config.gz)
>
> we are seeing similar lockups (at least similar for the results) since se=
veral
> kernel revisions (starting from 2.6.25.X) and on different hardware. Seve=
ral
> machines are hit by this, mostly databases (maybe for the specific usage,=
 other
> machines being apache servers, I don't know).
>
> Could someone give us some hints about this issue, or at least some
> suggestions on how to dig it? Of course we can do any sort of testing and
> tries.

You _could_ also try something like the attached patch. It's
completely untested, and could lead to data loss (depending on whether
the callers of this function expects/handles the error condition
gracefully). I really have no idea. If you try, be sure to back up
your data first. Good luck :-)

(It could also be something else entirely, but I think the stack trace
looks suspicious enough.)


Vegard

--=20
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

--001636c5b0546b679804671fc55a
Content-Type: application/octet-stream; name="xfs-deadlock.patch"
Content-Disposition: attachment; filename="xfs-deadlock.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftbiul9b1

ZGlmZiAtLWdpdCBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2J1Zi5jIGIvZnMveGZzL2xpbnV4LTIu
Ni94ZnNfYnVmLmMKaW5kZXggYWExMDE2Yi4uYjc5ZTcyNiAxMDA2NDQKLS0tIGEvZnMveGZzL2xp
bnV4LTIuNi94ZnNfYnVmLmMKKysrIGIvZnMveGZzL2xpbnV4LTIuNi94ZnNfYnVmLmMKQEAgLTM5
MCwyOSArMzkwLDEzIEBAIF94ZnNfYnVmX2xvb2t1cF9wYWdlcygKIAkgICAgICByZXRyeToKIAkJ
cGFnZSA9IGZpbmRfb3JfY3JlYXRlX3BhZ2UobWFwcGluZywgZmlyc3QgKyBpLCBnZnBfbWFzayk7
CiAJCWlmICh1bmxpa2VseShwYWdlID09IE5VTEwpKSB7Ci0JCQlpZiAoZmxhZ3MgJiBYQkZfUkVB
RF9BSEVBRCkgewotCQkJCWJwLT5iX3BhZ2VfY291bnQgPSBpOwotCQkJCWZvciAoaSA9IDA7IGkg
PCBicC0+Yl9wYWdlX2NvdW50OyBpKyspCi0JCQkJCXVubG9ja19wYWdlKGJwLT5iX3BhZ2VzW2ld
KTsKLQkJCQlyZXR1cm4gLUVOT01FTTsKLQkJCX0KKwkJCXByaW50ayhLRVJOX0VNRVJHICJYRlMg
Y291bGRuJ3QgZmluZF9vcl9jcmVhdGVfcGFnZSgpXG4iKTsKKwkJCVdBUk5fT05fT05DRSgxKTsK
IAotCQkJLyoKLQkJCSAqIFRoaXMgY291bGQgZGVhZGxvY2suCi0JCQkgKgotCQkJICogQnV0IHVu
dGlsIGFsbCB0aGUgWEZTIGxvd2xldmVsIGNvZGUgaXMgcmV2YW1wZWQgdG8KLQkJCSAqIGhhbmRs
ZSBidWZmZXIgYWxsb2NhdGlvbiBmYWlsdXJlcyB3ZSBjYW4ndCBkbyBtdWNoLgotCQkJICovCi0J
CQlpZiAoISgrK3JldHJpZXMgJSAxMDApKQotCQkJCXByaW50ayhLRVJOX0VSUgotCQkJCQkiWEZT
OiBwb3NzaWJsZSBtZW1vcnkgYWxsb2NhdGlvbiAiCi0JCQkJCSJkZWFkbG9jayBpbiAlcyAobW9k
ZToweCV4KVxuIiwKLQkJCQkJX19mdW5jX18sIGdmcF9tYXNrKTsKLQotCQkJWEZTX1NUQVRTX0lO
Qyh4Yl9wYWdlX3JldHJpZXMpOwotCQkJeGZzYnVmZF93YWtldXAoMCwgZ2ZwX21hc2spOwotCQkJ
Y29uZ2VzdGlvbl93YWl0KFdSSVRFLCBIWi81MCk7Ci0JCQlnb3RvIHJldHJ5OworCQkJYnAtPmJf
cGFnZV9jb3VudCA9IGk7CisJCQlmb3IgKGkgPSAwOyBpIDwgYnAtPmJfcGFnZV9jb3VudDsgaSsr
KQorCQkJCXVubG9ja19wYWdlKGJwLT5iX3BhZ2VzW2ldKTsKKwkJCXJldHVybiAtRU5PTUVNOwog
CQl9CiAKIAkJWEZTX1NUQVRTX0lOQyh4Yl9wYWdlX2ZvdW5kKTsK
--001636c5b0546b679804671fc55a--

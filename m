Return-Path: <linux-kernel-owner+w=401wt.eu-S966942AbXJSVIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966942AbXJSVIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966753AbXJSVIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:08:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:19650 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966854AbXJSVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=Gqe6oWVEigJ0iqdjs1BpwhwP/AZKD4Ek/M5zirGLJWtJrhuuHXLumCkXDz/DTBpbS9gXsdWfvCxjpEFNF3o2TpF2lYjnmp+Zd6gGzPKbR/2cPF2RlZVqP2ctkSSQseEeSvSo3e+kbVXUefgF3/p9x0akw+Wc4CgJcuG/SKqPpHo=
Message-ID: <70318cbf0710191408mfb372bah292028f7bafb6eec@mail.gmail.com>
Date: Fri, 19 Oct 2007 14:08:16 -0700
From: "Christopher Li" <sparse@chrisli.org>
To: "Alexey Dobriyan" <adobriyan@sw.ru>,
       "Josh Triplett" <josh@freedesktop.org>
Subject: [PATCH] Re: sparse breakage triggered by rcu_read_lock() lockdep annotations
Cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0710191244v59bed9fekbef0ae1fcda22a6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5118_17916161.1192828096056"
References: <20071016105521.GB6352@localhost.sw.ru>
	 <70318cbf0710191244v59bed9fekbef0ae1fcda22a6a@mail.gmail.com>
X-Google-Sender-Auth: 8389e7b514093692
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5118_17916161.1192828096056
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

OK, I get a trivial fix after all. The test case is fixed now.
I haven't done much test otherwise.

See the patch attached.

Chris


On 10/19/07, Chris Li <christ.li@gmail.com> wrote:
> Err,
>
> Sparse does not support the local label syntax yet. It just treats the
> second label "x:" as the same as the first one. Then the linearize
> code gets serious confused when it saw one label get define in two
> places.
>
> The fix seems not trivial from the first look.
>
> Chris
>
> On 10/16/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > FWIW, commit 851a67b825540a8e00c0be3ee25e4627ba8b133b
> > aka "lockdep: annotate rcu_read_{,un}lock{,_bh}"
> > causes sparse to trigger internal assertion in quite a few places over
> > allyesconfig run.
> >
> >         sparse: flow.c:805: rewrite_parent_branch: Assertion `changed' failed.
> >
> > Trimmed down testcase:
> >
> >         void f(unsigned long ip);
> >         static void g(void)
> >         {
> >                 if (1) {
> >                       f(({ __label__ x; x: (unsigned long)&&x; }));
> >                 }
> >                 f(({ __label__ x; x: (unsigned long)&&x; }));
> >         }
> >
> > #0  0x4001c410 in __kernel_vsyscall ()
> > (gdb) bt
> > #0  0x4001c410 in __kernel_vsyscall ()
> > #1  0x40050701 in raise () from /lib/libc.so.6
> > #2  0x40051e38 in abort () from /lib/libc.so.6
> > #3  0x40049fcc in __assert_fail () from /lib/libc.so.6
> > #4  0x08064947 in pack_basic_blocks (ep=0x411a1c6c) at flow.c:812
> > #5  0x0805ffbf in linearize_symbol (sym=0x4103ec8c) at linearize.c:2154
> > #6  0x080492a3 in main (argc=Cannot access memory at address 0x274d) at sparse.c:266
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>

------=_Part_5118_17916161.1192828096056
Content-Type: application/octet-stream; name=local-label
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f7z6uyun
Content-Disposition: attachment; filename=local-label

UGVyZm9ybSBsb2NhbCBsYWJlbCBsb29rdXAKClRoaXMgcGF0Y2ggZml4IHRoZSBzcGFyc2UgYnJl
YWthZ2UgdHJpZ2dlcmVkIGJ5CnJjdV9yZWFkX2xvY2soKSBsb2NrZGVwIGFubm90YXRpb25zLgoK
Tm93IHNwYXJzZSBsb29rIHVwIHRoZSBsb2NhbCBsYWJlbCBpbiBzeW1ib2wgbm9kZQpuYW1lIHNw
YWNlIGFzIHdlbGwsIGp1c3QgbGlrZSBsb29raW5nIHVwIGEgbm9ybWFsCnN5bWJvbCBub2RlLiBO
b3cgYSBsYWJsZSBzeW1ib2wgY2FuIGJlIGJvdGgKdHlwZSBTWU1fTEFCRUwgb3IgU1lNX05PREUg
d2l0aCBNT0RfTEFCRUwuCgpTaW5nZWQtT2ZmLUJ5OiBDaHJpc3RvcGhlciBMaSA8c3BhcnNlQGNo
cmlzbGkub3JnPgoKSW5kZXg6IHNwYXJzZS9wYXJzZS5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHNwYXJzZS5v
cmlnL3BhcnNlLmMJMjAwNy0xMC0xOSAxMzo1MjozNy4wMDAwMDAwMDAgLTA3MDAKKysrIHNwYXJz
ZS9wYXJzZS5jCTIwMDctMTAtMTkgMTM6NTU6MjMuMDAwMDAwMDAwIC0wNzAwCkBAIC00NTksNiAr
NDU5LDE2IEBAIHN0YXRpYyBzdHJ1Y3Qgc3ltYm9sICpsb29rdXBfb3JfY3JlYXRlX3MKIAlyZXR1
cm4gc3ltOwogfQogCitzdGF0aWMgc3RydWN0IHN5bWJvbCAqIGxvY2FsX2xhYmVsKHN0cnVjdCB0
b2tlbiAqdG9rZW4pCit7CisJc3RydWN0IHN5bWJvbCAqc3ltID0gbG9va3VwX3N5bWJvbCh0b2tl
bi0+aWRlbnQsIE5TX1NZTUJPTCk7CisKKwlpZiAoc3ltICYmIHN5bS0+Y3R5cGUubW9kaWZpZXJz
ICYgTU9EX0xBQkVMKQorCQlyZXR1cm4gc3ltOworCisJcmV0dXJuIE5VTEw7Cit9CisKIC8qCiAg
KiBOT1RFISBOU19MQUJFTCBpcyBub3QganVzdCBhIGRpZmZlcmVudCBuYW1lc3BhY2UsCiAgKiBp
dCBhbHNvIGVuZHMgdXAgdXNpbmcgZnVuY3Rpb24gc2NvcGUgaW5zdGVhZCBvZiB0aGUKQEAgLTQ2
Niw2ICs0NzYsOSBAQCBzdGF0aWMgc3RydWN0IHN5bWJvbCAqbG9va3VwX29yX2NyZWF0ZV9zCiAg
Ki8KIHN0cnVjdCBzeW1ib2wgKmxhYmVsX3N5bWJvbChzdHJ1Y3QgdG9rZW4gKnRva2VuKQogewor
CXN0cnVjdCBzeW1ib2wgKnN5bSA9IGxvY2FsX2xhYmVsKHRva2VuKTsKKwlpZiAoc3ltKQorCQly
ZXR1cm4gc3ltOwogCXJldHVybiBsb29rdXBfb3JfY3JlYXRlX3N5bWJvbChOU19MQUJFTCwgU1lN
X0xBQkVMLCB0b2tlbik7CiB9CiAKSW5kZXg6IHNwYXJzZS92YWxpZGF0aW9uL2xvY2FsLWxhYmVs
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gc3BhcnNlLm9yaWcvdmFsaWRhdGlvbi9sb2NhbC1sYWJlbC5jCTIw
MDctMTAtMTkgMTM6NTI6NDAuMDAwMDAwMDAwIC0wNzAwCisrKyBzcGFyc2UvdmFsaWRhdGlvbi9s
b2NhbC1sYWJlbC5jCTIwMDctMTAtMTkgMTM6NTI6NDAuMDAwMDAwMDAwIC0wNzAwCkBAIC0wLDAg
KzEsOCBAQAordm9pZCBmKHVuc2lnbmVkIGxvbmcgaXApOworc3RhdGljIHZvaWQgZyh2b2lkKQor
eworICAgICAgIGlmICgxKSB7CisJICAgICBmKCh7IF9fbGFiZWxfXyB4OyB4OiAodW5zaWduZWQg
bG9uZykmJng7IH0pKTsKKyAgICAgICB9CisgICAgICAgZigoeyBfX2xhYmVsX18geDsgeDogKHVu
c2lnbmVkIGxvbmcpJiZ4OyB9KSk7Cit9Cg==
------=_Part_5118_17916161.1192828096056--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZCMEz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZCMEz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZCMEzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:55:14 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:43080 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZCMEzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:55:13 -0400
Message-ID: <49B9E725.3060103@davidnewall.com>
Date: Fri, 13 Mar 2009 15:25:01 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hawking.rebel.net.au-21059-1236920109-0001-2"
To: Gene Heskett <gene.heskett@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I just got got another Oops
References: <200903120133.11583.gene.heskett@gmail.com> <200903121348.43477.gene.heskett@gmail.com> <49B96471.8070602@davidnewall.com> <200903121928.00746.gene.heskett@gmail.com>
In-Reply-To: <200903121928.00746.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hawking.rebel.net.au-21059-1236920109-0001-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Gene,

I think it's a null page pointer passed to prep_new_page.  It's
difficult to be certain, because it's compiled with -O2, but that's what
it looks like.

Let's test that hypothesis.  Let's also compile page_alloc.c with
debugging.  Do that by executing the commands in the attached file, and
then doing a make install (or whatever you do.)

But first, let's also sidestep the optimiser by making prep_new_page
public. Do that by changing:

   static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)**


in mm/page_alloc.c, near line 637, to:

   int my_prep_new_page(struct page *page, int order, gfp_t gfp_flags)**

and by changing:

	if (prep_new_page(page, order, gfp_flags))


near line 1137, to:

	if (my_prep_new_page(page, order, gfp_flags))


This will prevent the optimiser from inlining that function, and we
would expect to see the error change from
"get_page_from_freelist+0x24b/0x4c0" to "my_prep_new_page+0x0yy/0x0zz".

David

--=_hawking.rebel.net.au-21059-1236920109-0001-2
Content-Type: text/plain; name="compile_page_alloc"; charset=iso-8859-1
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="compile_page_alloc"

Z2NjIC1nIC1XcCwtTUQsbW0vLnBhZ2VfYWxsb2Muby5kICAtbm9zdGRpbmMgLWlzeXN0ZW0g
L3Vzci9saWIvZ2NjL2k0ODYtbGludXgtZ251LzQuMS4zL2luY2x1ZGUgLUlpbmNsdWRlICAt
SS9ob21lL2Rhdmlkbi9OQVMvbGludXgudHJlZXMuZ2l0L2FyY2gveDg2L2luY2x1ZGUgLWlu
Y2x1ZGUgaW5jbHVkZS9saW51eC9hdXRvY29uZi5oIC1EX19LRVJORUxfXyAtV2FsbCAtV3Vu
ZGVmIC1Xc3RyaWN0LXByb3RvdHlwZXMgLVduby10cmlncmFwaHMgLWZuby1zdHJpY3QtYWxp
YXNpbmcgLWZuby1jb21tb24gLVdlcnJvci1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlv
biAtbTMyIC1tc29mdC1mbG9hdCAtbXJlZ3Bhcm09MyAtZnJlZy1zdHJ1Y3QtcmV0dXJuIC1t
cHJlZmVycmVkLXN0YWNrLWJvdW5kYXJ5PTIgLW1hcmNoPWs4IC1tdHVuZT1nZW5lcmljIC1X
YSwtbXR1bmU9Z2VuZXJpYzMyIC1mZnJlZXN0YW5kaW5nIC1waXBlIC1Xbm8tc2lnbi1jb21w
YXJlIC1mbm8tYXN5bmNocm9ub3VzLXVud2luZC10YWJsZXMgLW1uby1zc2UgLW1uby1tbXgg
LW1uby1zc2UyIC1tbm8tM2Rub3cgLWZuby1zdGFjay1wcm90ZWN0b3IgLWZuby1vbWl0LWZy
YW1lLXBvaW50ZXIgLWZuby1vcHRpbWl6ZS1zaWJsaW5nLWNhbGxzIC1XZGVjbGFyYXRpb24t
YWZ0ZXItc3RhdGVtZW50IC1Xbm8tcG9pbnRlci1zaWduICAgLUQiS0JVSUxEX1NUUihzKT0j
cyIgLUQiS0JVSUxEX0JBU0VOQU1FPUtCVUlMRF9TVFIocGFnZV9hbGxvYykiICAtRCJLQlVJ
TERfTU9ETkFNRT1LQlVJTERfU1RSKHBhZ2VfYWxsb2MpIiAgLWMgLW8gbW0vcGFnZV9hbGxv
Yy5vIG1tL3BhZ2VfYWxsb2MuYwoKc2NyaXB0cy9iYXNpYy9maXhkZXAgbW0vLnBhZ2VfYWxs
b2Muby5kIG1tL3BhZ2VfYWxsb2MubyAnZ2NjIGV0YycgPiBtbS8ucGFnZV9hbGxvYy5vLnRt
cApybSAtZiBtbS8ucGFnZV9hbGxvYy5vLmQKbXYgLWYgbW0vLnBhZ2VfYWxsb2Muby50bXAg
bW0vLnBhZ2VfYWxsb2Muby5jbWQK
--=_hawking.rebel.net.au-21059-1236920109-0001-2--

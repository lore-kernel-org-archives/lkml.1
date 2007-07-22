Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbXGVXvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbXGVXvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761790AbXGVXuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:50:50 -0400
Received: from ag-out-0708.google.com ([72.14.246.244]:44581 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbXGVXut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=eFhMycEmjXAd7U8T+iPEE6s+d3kxJUAeY23yyNkScqNJGwqFz4VGx6AKoK1kP/qM82FuwCNpOLGgHAVlnjZkdddkuu0vh26RHIWhUKJYIai3qYvyzN4fBBO5tCrO4DUU7fP4rtZUcjQGYK0LCmOGiu487Yxv89Z61+X5CqI+URM=
Message-ID: <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
Date: Sun, 22 Jul 2007 19:50:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: early_printk accessing __log_buf
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
In-Reply-To: <200707182358.24984.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_151911_7705382.1185148247724"
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <200707181939.46910.rgetz@blackfin.uclinux.org>
	 <20070718172603.231351ea.akpm@linux-foundation.org>
	 <200707182358.24984.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_151911_7705382.1185148247724
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/18/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Wed 18 Jul 2007 20:26, Andrew Morton pondered:
> > Robin Getz wrote:
> > > [need to access _log_buf from external for early debugging code]
> > >
> > > Something simple like - early_copy_log_buff(void *dest, size_t n)
> > >
> > > copies n bytes from log_buf to memory area dest. Returns number of
> > > bytes that could not be copied. Can find out how many bytes are in
> > > the log_buff by calling with zero size.
> >
> > When I was at $EARLIER_EMPLOYER, we had code in there to copy the last
> > kilobyte-odd of the log buffer into flash when the box oopsed.
> >
>
> Hmm - I think that if you call with NULL dest, and have it advance the
> pointer, you could do the same thing with something like:
>
>  /* see how many bytes are in the buff */
>  length = early_copy_log_buff(NULL, NULL);
>  /* advance the pointer, so we only copy the last 1k */
>  if (length >= 1024 )
>     left = early_copy_log_buff(NULL, length - 1024);
>  /* copy to temp buffer, to save to flash */
>  early_copy_log_buff(buff, 1024);
>  save_buff_to_flash(buff);
>
> That way - you can put this in the standard places for failure, and still have
> only one function polluting printk.c (Although if you want to use it for
> failure trapping - it's up for "normal" run time use, and doesn't go into
> __init.
>
> > Probably there are others, but they'll mainly be in the consumer/embedded
> >  area, and those sorts of engineers don't read this mailing list much.
>
> Adding a few more 'embedded' folks - who might have some thoughts/opinions.

i think the attached two functions account for what Robin and Andrew
were thinking ...
-mike

------=_Part_151911_7705382.1185148247724
Content-Type: application/octet-stream; name="linux-log_buf_read.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="linux-log_buf_read.patch"
X-Attachment-Id: f_f4g6no4g

QWRkIHR3byBuZXcgZnVuY3Rpb25zIGZvciByZWFkaW5nIHRoZSBrZXJuZWwgbG9nIGJ1ZmZlci4g
IFRoZWlyIGludGVudGlvbgppcyB0byBiZSB1c2VkIGJ5IHJlY292ZXJ5L2R1bXAvZGVidWcgY29k
ZSBzbyB0aGUga2VybmVsIGxvZyBjYW4gYmUgZWFzaWx5CnJldHJpZXZlZC9wYXJzZWQgaW4gYSBj
cmFzaCBzY2VuYXJpbywgYnV0IHRoZXkgYXJlIGdlbmVyaWMgZW5vdWdoIGZvciBvdGhlcgpwZW9w
bGUgdG8gZHJlYW0gdXAgb3RoZXIgZnVuIHVzZXMuCgpTaWduZWQtb2ZmLWJ5OiBNaWtlIEZyeXNp
bmdlciA8dmFwaWVyQGdlbnRvby5vcmc+Ci0tLQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9r
ZXJuZWwuaCBiL2luY2x1ZGUvbGludXgva2VybmVsLmgKaW5kZXggNDMwMGJiNC4uM2ZjYzA5ZSAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9rZXJuZWwuaAorKysgYi9pbmNsdWRlL2xpbnV4L2tl
cm5lbC5oCkBAIC0xNTYsNiArMTU2LDggQEAgYXNtbGlua2FnZSBpbnQgdnByaW50ayhjb25zdCBj
aGFyICpmbXQsIHZhX2xpc3QgYXJncykKIAlfX2F0dHJpYnV0ZV9fICgoZm9ybWF0IChwcmludGYs
IDEsIDApKSk7CiBhc21saW5rYWdlIGludCBwcmludGsoY29uc3QgY2hhciAqIGZtdCwgLi4uKQog
CV9fYXR0cmlidXRlX18gKChmb3JtYXQgKHByaW50ZiwgMSwgMikpKSBfX2NvbGQ7CitleHRlcm4g
aW50IGxvZ19idWZfcmVhZChpbnQgbGVuLCBjaGFyICpidWYsIGludCBncmFiX2xvY2spOworZXh0
ZXJuIGludCBsb2dfYnVmX3JlYWRfYnl0ZShpbnQgaWR4LCBjaGFyICpieXRlLCBpbnQgZ3JhYl9s
b2NrKTsKICNlbHNlCiBzdGF0aWMgaW5saW5lIGludCB2cHJpbnRrKGNvbnN0IGNoYXIgKnMsIHZh
X2xpc3QgYXJncykKIAlfX2F0dHJpYnV0ZV9fICgoZm9ybWF0IChwcmludGYsIDEsIDApKSk7CkBA
IC0xNjMsNiArMTY1LDggQEAgc3RhdGljIGlubGluZSBpbnQgdnByaW50ayhjb25zdCBjaGFyICpz
LCB2YV9saXN0IGFyZ3MpIHsgcmV0dXJuIDA7IH0KIHN0YXRpYyBpbmxpbmUgaW50IHByaW50ayhj
b25zdCBjaGFyICpzLCAuLi4pCiAJX19hdHRyaWJ1dGVfXyAoKGZvcm1hdCAocHJpbnRmLCAxLCAy
KSkpOwogc3RhdGljIGlubGluZSBpbnQgX19jb2xkIHByaW50ayhjb25zdCBjaGFyICpzLCAuLi4p
IHsgcmV0dXJuIDA7IH0KK3N0YXRpYyBpbmxpbmUgaW50IGxvZ19idWZfcmVhZChpbnQgbGVuLCBj
aGFyICpidWYsIGludCBncmFiX2xvY2spIHsgcmV0dXJuIDA7IH0KK3N0YXRpYyBpbmxpbmUgaW50
IGxvZ19idWZfcmVhZF9ieXRlKGludCBsZW4sIGNoYXIgKmJ1ZiwgaW50IGdyYWJfbG9jaykgeyBy
ZXR1cm4gMDsgfQogI2VuZGlmCiAKIHVuc2lnbmVkIGxvbmcgaW50X3NxcnQodW5zaWduZWQgbG9u
Zyk7CmRpZmYgLS1naXQgYS9rZXJuZWwvcHJpbnRrLmMgYi9rZXJuZWwvcHJpbnRrLmMKaW5kZXgg
MDUxZDI3ZS4uZjA4ZGJmNSAxMDA2NDQKLS0tIGEva2VybmVsL3ByaW50ay5jCisrKyBiL2tlcm5l
bC9wcmludGsuYwpAQCAtMTYzLDYgKzE2Myw3MSBAQCBvdXQ6CiBfX3NldHVwKCJsb2dfYnVmX2xl
bj0iLCBsb2dfYnVmX2xlbl9zZXR1cCk7CiAKIC8qCisgKiBSZWFkIHRoZSBsb2cgYnVmZmVyIGlu
dG8gdGhlIHN1cHBsaWVkIGJ1ZmZlci4gIFRoZSBsZW4gb3B0aW9uCisgKiB0ZWxscyB3aGV0aGVy
IHRvIGNvcHkgZnJvbSB0aGUgYmVnaW5uaW5nICg+IDApLCB0aGUgZW5kICg8IDApLCBvcgorICog
anVzdCBxdWVyeSB0aGUgbnVtYmVyIG9mIGV4aXN0aW5nIGNoYXJzLiAgIFRoZSBudW1iZXIgb2Yg
Ynl0ZXMKKyAqIGFjdHVhbGx5IGNvcGllZCBpcyByZXR1cm5lZC4KKyAqLworaW50IGxvZ19idWZf
cmVhZChpbnQgbGVuLCBjaGFyICpidWYsIGludCBncmFiX2xvY2spCit7CisJdW5zaWduZWQgbG9u
ZyBzdGFydCwgZW5kOworCWludCBudW1fdG9fY29weTsKKworCWlmIChsZW4gPT0gMCkKKwkJcmV0
dXJuIGxvZ19lbmQgLSBsb2dfc3RhcnQ7CisKKwlpZiAoZ3JhYl9sb2NrKQorCQlzcGluX2xvY2tf
aXJxKCZsb2didWZfbG9jayk7CisKKwludW1fdG9fY29weSA9IG1pbihhYnMobGVuKSwgYWJzKGxv
Z19lbmQgLSBsb2dfc3RhcnQpKTsKKworCWlmIChsZW4gPCAwKSB7CisJCXN0YXJ0ID0gbG9nX2Vu
ZCAtIG51bV90b19jb3B5OworCQllbmQgPSBsb2dfZW5kOworCX0gZWxzZSB7CisJCXN0YXJ0ID0g
bG9nX3N0YXJ0OworCQllbmQgPSBsb2dfc3RhcnQgKyBudW1fdG9fY29weTsKKwl9CisKKwl3aGls
ZSAoc3RhcnQgIT0gZW5kKQorCQkqYnVmKysgPSBMT0dfQlVGKHN0YXJ0KyspOworCisJaWYgKGdy
YWJfbG9jaykKKwkJc3Bpbl91bmxvY2tfaXJxKCZsb2didWZfbG9jayk7CisKKwlyZXR1cm4gbnVt
X3RvX2NvcHk7Cit9CisKKy8qCisgKiBHcmFiIGEgc2luZ2xlIGJ5dGUgb3V0IG9mIHRoZSBsb2cg
YnVmZmVyLiAgVGhlIGlkeCBvcHRpb24KKyAqIHRlbGxzIHdoZXRoZXIgdG8gaW5kZXggZnJvbSB0
aGUgYmVnaW5uaW5nICg+PSAwKSBvciB0aGUKKyAqIGVuZCAoPCAwKSBvZiB0aGUgYnVmZmVyLgor
ICovCitpbnQgbG9nX2J1Zl9yZWFkX2J5dGUoaW50IGlkeCwgY2hhciAqYnl0ZSwgaW50IGdyYWJf
bG9jaykKK3sKKwlpbnQgcmV0ID0gMTsKKworCWlmIChncmFiX2xvY2spCisJCXNwaW5fbG9ja19p
cnEoJmxvZ2J1Zl9sb2NrKTsKKworCWlmIChhYnMoaWR4KSA+PSBsb2dfYnVmX2xlbiB8fCBhYnMo
aWR4KSA+PSBsb2dnZWRfY2hhcnMpIHsKKwkJcmV0ID0gLTE7CisJCWdvdG8gZG9uZTsKKwl9CisK
KwlpZiAoaWR4IDwgMCkKKwkJKmJ5dGUgPSBMT0dfQlVGKGxvZ19lbmQgKyBpZHgpOworCWVsc2UK
KwkJKmJ5dGUgPSBMT0dfQlVGKGxvZ19zdGFydCArIGlkeCk7CisKKyBkb25lOgorCWlmIChncmFi
X2xvY2spCisJCXNwaW5fdW5sb2NrX2lycSgmbG9nYnVmX2xvY2spOworCisJcmV0dXJuIHJldDsK
K30KKworLyoKICAqIENvbW1hbmRzIHRvIGRvX3N5c2xvZzoKICAqCiAgKiAJMCAtLSBDbG9zZSB0
aGUgbG9nLiAgQ3VycmVudGx5IGEgTk9QLgo=
------=_Part_151911_7705382.1185148247724--

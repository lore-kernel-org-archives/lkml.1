Return-Path: <linux-kernel-owner+w=401wt.eu-S936269AbXGWUyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936269AbXGWUyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935262AbXGWUyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:54:39 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:23720 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbXGWUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=O5oLi2yc5CKMNScq5+1oe0KqLstIVCT8qCy8AFJsqiFblIjFdMIaz1aBhnOFI0Vkf9sUzJcyrqgfMl8CRvQ54Sq25BC7cBvKJh4+VC7qK84Peipt8eyq1pqxYrsBqB92l/+2AVcXlbqnvO9feqjI5KzDBvEwkLCJKyJa9wniuLs=
Message-ID: <8bd0f97a0707231354k7732f647qc0b55f105440ca1c@mail.gmail.com>
Date: Mon, 23 Jul 2007 16:54:36 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
In-Reply-To: <20070723131553.2943861f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_165853_1274058.1185224076025"
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <200707182358.24984.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
	 <200707231419.13182.rgetz@blackfin.uclinux.org>
	 <20070723131553.2943861f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_165853_1274058.1185224076025
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 23 Jul 2007 14:19:12 -0400
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>
> > On Sun 22 Jul 2007 19:50, Mike Frysinger pondered:
> > >
> > > i think the attached two functions account for what Robin and Andrew
> > > were thinking ...
> >
> > A note about why/when grab_lock would be set to zero (pre-kernel init, or
> > OOPs) might be nice.
>
> Definitely.
>
> The pre-kernel init shouldn't be an issue: logbuf_lock is initialised at
> compile time.
>
> At oops time we could possibly use oops_in_progress to work out whether to
> avoid taking the lock.  That's not terribly nice, but nor is it nice for
> callers to know about printk internals.

maybe, but for early debug users (the reason we wanted this
originally), it wouldnt be an oops in progress ... but i guess we can
just as easily set oops_in_progress to 1 in our code before calling
this function to keep from having to worry over locks from being
doubly grabbed.

> > Or - remove it - and tell people they should be using do_syslog interface in
> > a "normal" kernel environment (where log_end or log_start can be updated).
>
> You can't (or al least, shouldn't) use do_syslog() from within kernel code?
>
> > Either would be fine with me. Andrew?
>
> The interface is pretty bad, IMO:
>
>  /*
> + * Read the log buffer into the supplied buffer.  The len option
> + * tells whether to copy from the beginning (> 0), the end (< 0), or
> + * just query the number of existing chars.   The number of bytes
> + * actually copied is returned.
> + */
> +int log_buf_read(int len, char *buf, int grab_lock)
>
> The magical interpretation of len isn't very nice.  This code would be
> simpler if it did not attempt to read more than one char at a time.  It
> will be plenty fast enough.
>
> If the caller knows the length of the buffer, why is there any need for the
> index-from-the-end function?

fair enough ... my php side likes to overload the meaning of length :)

> I think a sufficient implementation is
>
>         int log_buf_len(void);
>
> and
>
>         int log_buf_read(int index);
>
> which will return the character at `index', or -1 if `index' is out of
> bounds.

the idea originally was to have a buffer based function and an index
based function due to the idea of copying chunks of the log at a time,
but i kind of forgot about that once was all said and done.  now that
i look at it, unless the buffer based function dives into the log
internals to figure out how to split the copy based on the log
wraparound, there's no need for it.

log_buf_len is already the variable used to track the size, so the
function is called 'log_buf_get_len()' ...
-mike

------=_Part_165853_1274058.1185224076025
Content-Type: application/octet-stream; name=linux-log_buf_read.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4hfsjbf
Content-Disposition: attachment; filename="linux-log_buf_read.patch"

QWRkIHR3byBuZXcgZnVuY3Rpb25zIGZvciByZWFkaW5nIHRoZSBrZXJuZWwgbG9nIGJ1ZmZlci4g
IFRoZWlyIGludGVudGlvbgppcyB0byBiZSB1c2VkIGJ5IHJlY292ZXJ5L2R1bXAvZGVidWcgY29k
ZSBzbyB0aGUga2VybmVsIGxvZyBjYW4gYmUgZWFzaWx5CnJldHJpZXZlZC9wYXJzZWQgaW4gYSBj
cmFzaCBzY2VuYXJpbywgYnV0IHRoZXkgYXJlIGdlbmVyaWMgZW5vdWdoIGZvciBvdGhlcgpwZW9w
bGUgdG8gZHJlYW0gdXAgb3RoZXIgZnVuIHVzZXMuCgpTaWduZWQtb2ZmLWJ5OiBNaWtlIEZyeXNp
bmdlciA8dmFwaWVyQGdlbnRvby5vcmc+Ci0tLQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9r
ZXJuZWwuaCBiL2luY2x1ZGUvbGludXgva2VybmVsLmgKaW5kZXggNDMwMGJiNC4uYmFhNjYxYyAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9rZXJuZWwuaAorKysgYi9pbmNsdWRlL2xpbnV4L2tl
cm5lbC5oCkBAIC0xNTYsNiArMTU2LDggQEAgYXNtbGlua2FnZSBpbnQgdnByaW50ayhjb25zdCBj
aGFyICpmbXQsIHZhX2xpc3QgYXJncykKIAlfX2F0dHJpYnV0ZV9fICgoZm9ybWF0IChwcmludGYs
IDEsIDApKSk7CiBhc21saW5rYWdlIGludCBwcmludGsoY29uc3QgY2hhciAqIGZtdCwgLi4uKQog
CV9fYXR0cmlidXRlX18gKChmb3JtYXQgKHByaW50ZiwgMSwgMikpKSBfX2NvbGQ7CitleHRlcm4g
aW50IGxvZ19idWZfZ2V0X2xlbih2b2lkKTsKK2V4dGVybiBpbnQgbG9nX2J1Zl9yZWFkKGludCBp
ZHgpOwogI2Vsc2UKIHN0YXRpYyBpbmxpbmUgaW50IHZwcmludGsoY29uc3QgY2hhciAqcywgdmFf
bGlzdCBhcmdzKQogCV9fYXR0cmlidXRlX18gKChmb3JtYXQgKHByaW50ZiwgMSwgMCkpKTsKQEAg
LTE2Myw2ICsxNjUsOCBAQCBzdGF0aWMgaW5saW5lIGludCB2cHJpbnRrKGNvbnN0IGNoYXIgKnMs
IHZhX2xpc3QgYXJncykgeyByZXR1cm4gMDsgfQogc3RhdGljIGlubGluZSBpbnQgcHJpbnRrKGNv
bnN0IGNoYXIgKnMsIC4uLikKIAlfX2F0dHJpYnV0ZV9fICgoZm9ybWF0IChwcmludGYsIDEsIDIp
KSk7CiBzdGF0aWMgaW5saW5lIGludCBfX2NvbGQgcHJpbnRrKGNvbnN0IGNoYXIgKnMsIC4uLikg
eyByZXR1cm4gMDsgfQorc3RhdGljIGlubGluZSBpbnQgbG9nX2J1Zl9nZXRfbGVuKHZvaWQpIHsg
cmV0dXJuIDA7IH0KK3N0YXRpYyBpbmxpbmUgaW50IGxvZ19idWZfcmVhZChpbnQgaWR4KTsgeyBy
ZXR1cm4gMDsgfQogI2VuZGlmCiAKIHVuc2lnbmVkIGxvbmcgaW50X3NxcnQodW5zaWduZWQgbG9u
Zyk7CmRpZmYgLS1naXQgYS9rZXJuZWwvcHJpbnRrLmMgYi9rZXJuZWwvcHJpbnRrLmMKaW5kZXgg
MDUxZDI3ZS4uZmFlNDM2NyAxMDA2NDQKLS0tIGEva2VybmVsL3ByaW50ay5jCisrKyBiL2tlcm5l
bC9wcmludGsuYwpAQCAtMTYzLDYgKzE2MywzNSBAQCBvdXQ6CiBfX3NldHVwKCJsb2dfYnVmX2xl
bj0iLCBsb2dfYnVmX2xlbl9zZXR1cCk7CiAKIC8qCisgKiBSZXR1cm4gdGhlIG51bWJlciBvZiB1
bnJlYWQgY2hhcmFjdGVycyBpbiB0aGUgbG9nIGJ1ZmZlci4KKyAqLworaW50IGxvZ19idWZfZ2V0
X2xlbih2b2lkKQoreworCXJldHVybiBsb2dfZW5kIC0gbG9nX3N0YXJ0OworfQorCisvKgorICog
RXh0cmFjdCBhIGNoYXJhY3RlciBmcm9tIHRoZSBsb2cgYnVmZmVyLgorICovCitpbnQgbG9nX2J1
Zl9yZWFkKGludCBpZHgpCit7CisJaW50IHJldDsKKworCWlmICghb29wc19pbl9wcm9ncmVzcykK
KwkJc3Bpbl9sb2NrX2lycSgmbG9nYnVmX2xvY2spOworCisJaWYgKGlkeCA8IDAgfHwgaWR4ID49
IGxvZ19idWZfZ2V0X2xlbigpKQorCQlyZXQgPSAtMTsKKwllbHNlCisJCXJldCA9IExPR19CVUYo
aWR4KTsKKworCWlmICghb29wc19pbl9wcm9ncmVzcykKKwkJc3Bpbl91bmxvY2tfaXJxKCZsb2di
dWZfbG9jayk7CisKKwlyZXR1cm4gcmV0OworfQorCisvKgogICogQ29tbWFuZHMgdG8gZG9fc3lz
bG9nOgogICoKICAqIAkwIC0tIENsb3NlIHRoZSBsb2cuICBDdXJyZW50bHkgYSBOT1AuCg==
------=_Part_165853_1274058.1185224076025--

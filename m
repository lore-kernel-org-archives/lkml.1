Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXGBNmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXGBNmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXGBNmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:42:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbXGBNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=J4mxCn4gZAH0TIJIIRFHYmNaRYHwM/CxgYDJDSiC74yTnskg7tDcmdy9QmzOZ+rz/CWqMLQ4TwhVpb6xYEtZOZJ0V7xxDI9TtkDdhkBCjXWru5HrrMHtyXBFZq9Pg3+wyWn/lDZ0KLuLoYYsRV+n3R3gDOVOsOlk/xv0yn6wv0I=
Message-ID: <d120d5000707020642j752ca814l501aaa543f9babcf@mail.gmail.com>
Date: Mon, 2 Jul 2007 09:42:04 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: blink driver power saving
Cc: "Indan Zupancic" <indan@nul.nu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, bwalle@suse.de
In-Reply-To: <200707021439.27357.ak@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_84969_7607821.1183383724307"
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
	 <200707021351.57965.ak@suse.de>
	 <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com>
	 <200707021439.27357.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_84969_7607821.1183383724307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/2/07, Andi Kleen <ak@suse.de> wrote:
>
> > > Perhaps one of you geniuses who all hate it can find a better way to
> > > solve the "video output dead after kexec; but need visual feedback to the user
> > > while crash dumping" problem. I'm waiting for your patches.
> > >
> >
> > I don't don't like it ;) Unfortunately too many people end up enabling
>
> Yes that's pretty weird. I admit I hadn't expected
> that problem. blink is equivalent to "annoy me" and it
> is a mystery why so many people should willingly ask their computer to
> annoy them.
>
> Or perhaps they update their configs with yes | make oldconfig?
>
> User psychology can be mysterious.
>
> I wonder if the kernel offered a CONFIG_FORMAT_FILESYSTEMS_AT_BOOT
> how many people would enable that @) Might be an interesting experiment
> for next April.
>

Heh ;) That could be interesting.

> > it and having issues with their keyboards.
>
> Forcing a suitable slow rate should fix that shouldn't it? We need
> that anyways to stop the "setleds DOS".
>

I already have a patch that throttles AT keyboard when switching LED
state. However there is another problem - i8042's interrupt hanler is
racing with panic_blink polling the keyboar controller and they both
don;t quite like that.

> > Can we have it depend on
> > DEBUG_KERNEL?
>
> Yes that would be probably a good idea; even though it is technically
> not correct: the debug kernel doesn't try to debug itself. But anyways,
> it's probably the best place.
>
> > And probably KEXEC as well?
>
> The kcrash kernel doesn't necessarily need to have kexec enabled by
> itself.
>

OK.

> > Another option would be for it not use panic_blink. Do your kexec
> > kernels have atkbd support enabled? You could write an new "blink"
> > input handler that would latch to keyboards supporting leds and blink
> > by sending EV_LED events.
>
> Yes that would be probably a better implementation. Also hook something
> for USB keyboards. iirc Bernhard Walle (cc'ed) was looking at that.
>

I was thinking about something like the atached (untested and sorry
for using attachment). It shoudl blink just one led (numLock) on any
keyboard that has such LED (and allows to control it).

-- 
Dmitry

------=_Part_84969_7607821.1183383724307
Content-Type: text/plain; name=blink.c; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3n0319r
Content-Disposition: attachment; filename="blink.c"

LyoKICogRGVidWcgZHJpdmVyIHRoYXQgY29udGludW9zbHkgYmxpbmsgTEVEcyBvbiBrZXlib2Fy
ZHMKICoKICogQ29weXJpZ2h0IChjKSAyMDA3IERtaXRyeSBUb3Jva2hvdgogKi8KCi8qCiAqIFRo
aXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQv
b3IgbW9kaWZ5IGl0CiAqIHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UgdmVyc2lvbiAyIGFzIHB1Ymxpc2hlZAogKiBieSB0aGUgRnJlZSBTb2Z0d2FyZSBG
b3VuZGF0aW9uLgogKi8KCiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KI2luY2x1ZGUgPGxpbnV4
L2lucHV0Lmg+CiNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiNpbmNsdWRlIDxsaW51eC93b3JrcXVl
dWUuaD4KI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KCk1PRFVMRV9BVVRIT1IoIkRtaXRyeSBUb3Jv
a2hvdiA8ZHRvckBtYWlsLnJ1PiIpOwpNT0RVTEVfREVTQ1JJUFRJT04oIkJsaW5rIGRyaXZlciIp
OwpNT0RVTEVfTElDRU5TRSgiR1BMIik7CgpzdHJ1Y3QgYmxpbmtlciB7CglzdHJ1Y3QgZGVsYXll
ZF93b3JrIHdvcms7CglzdHJ1Y3QgaW5wdXRfaGFuZGxlIGhhbmRsZTsKCWludCBzdGF0ZTsKfTsK
CnN0YXRpYyB2b2lkIGJsaW5rX3Rhc2tfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
CnsKCXN0cnVjdCBibGlua2VyICpibGlua2VyID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBi
bGlua2VyLCB3b3JrLndvcmspOwoKCWJsaW5rZXItPnN0YXRlID0gIWJsaW5rZXItPnN0YXRlOwoJ
aW5wdXRfaW5qZWN0X2V2ZW50KCZibGlua2VyLT5oYW5kbGUsIEVWX0xFRCwgTEVEX05VTUwsIGJs
aW5rZXItPnN0YXRlKTsKCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmYmxpbmtlci0+d29yaywgbXNl
Y3NfdG9famlmZmllcygyNTApKTsKfQoKc3RhdGljIHZvaWQgYmxpbmtfZXZlbnQoc3RydWN0IGlu
cHV0X2hhbmRsZSAqaGFuZGxlLCB1bnNpZ25lZCBpbnQgdHlwZSwKCQkgICAgICAgIHVuc2lnbmVk
IGludCBjb2RlLCBpbnQgZG93bikKewoJLyoKCSAqIFRoaXMgaXMgYSB2ZXJ5IHJhcmUgaGFuZGxl
ciB0aGF0IGRvZXMgbm90IHByb2Nlc3MgYW55IGlucHV0CgkgKiBldmVudHM7IGp1c3QgaW5qZWN0
cyB0aGVtLgoJICovCn0KCnN0YXRpYyBpbnQgYmxpbmtfY29ubmVjdChzdHJ1Y3QgaW5wdXRfaGFu
ZGxlciAqaGFuZGxlciwgc3RydWN0IGlucHV0X2RldiAqZGV2LAoJCQkgIGNvbnN0IHN0cnVjdCBp
bnB1dF9kZXZpY2VfaWQgKmlkKQp7CglzdHJ1Y3QgYmxpbmtlciAqYmxpbmtlcjsKCXN0cnVjdCBp
bnB1dF9oYW5kbGUgKmhhbmRsZTsKCWludCBlcnJvcjsKCglibGlua2VyID0ga3phbGxvYyhzaXpl
b2Yoc3RydWN0IGJsaW5rZXIpLCBHRlBfS0VSTkVMKTsKCWlmICghYmxpbmtlcikKCQlyZXR1cm4g
LUVOT01FTTsKCglJTklUX0RFTEFZRURfV09SSygmYmxpbmtlci0+d29yaywgYmxpbmtfdGFza19o
YW5kbGVyKTsKCgloYW5kbGUgPSAmYmxpbmtlci0+aGFuZGxlOwoJaGFuZGxlLT5kZXYgPSBkZXY7
CgloYW5kbGUtPmhhbmRsZXIgPSBoYW5kbGVyOwoJaGFuZGxlLT5uYW1lID0gImJsaW5rIjsKCWhh
bmRsZS0+cHJpdmF0ZSA9IGJsaW5rZXI7CgoJZXJyb3IgPSBpbnB1dF9yZWdpc3Rlcl9oYW5kbGUo
aGFuZGxlKTsKCWlmIChlcnJvcikKCQlnb3RvIGVycl9mcmVlX2hhbmRsZTsKCgllcnJvciA9IGlu
cHV0X29wZW5fZGV2aWNlKGhhbmRsZSk7CglpZiAoZXJyb3IpCgkJZ290byBlcnJfdW5yZWdpc3Rl
cl9oYW5kbGU7CgoJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZibGlua2VyLT53b3JrLCAwKTsKCgly
ZXR1cm4gMDsKCiBlcnJfdW5yZWdpc3Rlcl9oYW5kbGU6CglpbnB1dF91bnJlZ2lzdGVyX2hhbmRs
ZShoYW5kbGUpOwogZXJyX2ZyZWVfaGFuZGxlOgoJa2ZyZWUoaGFuZGxlKTsKCXJldHVybiBlcnJv
cjsKfQoKc3RhdGljIHZvaWQgYmxpbmtfZGlzY29ubmVjdChzdHJ1Y3QgaW5wdXRfaGFuZGxlICpo
YW5kbGUpCnsKCXN0cnVjdCBibGlua2VyICpibGlua2VyID0gaGFuZGxlLT5wcml2YXRlOwoKCWNh
bmNlbF9yZWFybWluZ19kZWxheWVkX3dvcmsoJmJsaW5rZXItPndvcmspOwoJaW5wdXRfY2xvc2Vf
ZGV2aWNlKGhhbmRsZSk7CglpbnB1dF91bnJlZ2lzdGVyX2hhbmRsZShoYW5kbGUpOwoJa2ZyZWUo
Ymxpbmtlcik7Cn0KCnN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5wdXRfZGV2aWNlX2lkIGJsaW5rX2lk
c1tdID0gewoJewoJCS5mbGFncyA9IElOUFVUX0RFVklDRV9JRF9NQVRDSF9FVkJJVCB8IElOUFVU
X0RFVklDRV9JRF9NQVRDSF9MRURCSVQsCgkJLmV2Yml0ID0geyBCSVQoRVZfTEVEKSB9LAoJCS5r
ZXliaXQgPSB7IFtMT05HKExFRF9OVU1MKV0gPSBCSVQoTEVEX05VTUwpIH0sCgl9LAoJeyB9Cn07
CgpzdGF0aWMgc3RydWN0IGlucHV0X2hhbmRsZXIgYmxpbmtfaGFuZGxlciA9IHsKCS5ldmVudAkJ
PSBibGlua19ldmVudDsKCS5jb25uZWN0CT0gYmxpbmtfY29ubmVjdCwKCS5kaXNjb25uZWN0CT0g
YmxpbmtfZGlzY29ubmVjdCwKCS5uYW1lCQk9ICJibGluayIsCgkuaWRfdGFibGUJPSBibGlua19p
ZHMsCn07CgpzdGF0aWMgaW50IF9faW5pdCBibGlua19oYW5kbGVyX2luaXQodm9pZCkKewoJcmV0
dXJuIGlucHV0X3JlZ2lzdGVyX2hhbmRsZXIoJmJsaW5rX2hhbmRsZXIpOwp9CgpzdGF0aWMgdm9p
ZCBfX2V4aXQgYmxpbmtfaGFuZGxlcl9leGl0KHZvaWQpCnsKCWlucHV0X3VucmVnaXN0ZXJfaGFu
ZGxlcigmYmxpbmtfaGFuZGxlcik7CglmbHVzaF9zY2hlZHVsZWRfd29yaygpOwp9Cgptb2R1bGVf
aW5pdChibGlua19oYW5kbGVyX2luaXQpOwptb2R1bGVfZXhpdChibGlua19oYW5kbGVyX2V4aXQp
Owo=
------=_Part_84969_7607821.1183383724307--

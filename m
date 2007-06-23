Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXFWNb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXFWNb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760728AbXFWN1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:27:20 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:64399 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760282AbXFWN1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=lWcAguXwd7nk4LFZJjH5YeR704SpMTFXH9wAc0IDOynLNLXqIQsbYuM5/4O/csy6hEqWb8+7dTzvOqiVppwO02LtKELyTbOve24U0d55iAg2hq9yO7QOKxBMIPrdScl+WLg1GpztGXOOLq3qT91Ei03vTU0OMag1MF1A0P+IUKI=
Message-ID: <a781481a0706230627q5d6ae3dcu49e197b3bdf7090f@mail.gmail.com>
Date: Sat, 23 Jun 2007 18:57:14 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
Subject: Re: Problems with -rc5 afterall on Dreamcast
Cc: linux-sh <linuxsh-dev@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Paul Mundt" <lethal@linux-sh.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <1182597325.6001.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_131146_16281728.1182605234225"
References: <1182597325.6001.0.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_131146_16281728.1182605234225
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Adrian,

On 6/23/07, Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> Previously it had compiled and built cleanly, but when I added in the
> sound driver I got this:
>
>   MODPOST vmlinux
> WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
> mismatch: reference to .init.text: (between 'mv_dreamcast' and
> 'systemasic_int')

Ok, this one looks to have come from
2c7834a6f15fe6c50ed4766f1bb6f9183b9e2740

Basically, when !SH_GENERIC && !SH_UNKNOWN,
__initmv == (nothing), so the machine vectors will go to .data section.

But all the corresponding .mv_setup members of the sh_machine_vector
are setup to point to functions that are marked __init unconditionally,
which causes these reference warnings. Marking  the corresponding
.mv_setup functions as __initmv too would silence these (bogus)
warnings, but Paul must confirm if this is desirable and correct
(basically can it make sense to put *functions* into the .machvec.init
section too)?

Similar cases in:
-> arch/sh/boards/dreamcast/setup.c:dreamcast_setup()
-> arch/sh/boards/hp6xx/setup.c:hp6xx_setup()
-> arch/sh/boards/landisk/setup.c:landisk_setup()
-> arch/sh/boards/mpc1211/setup.c:mpc1211_setup()
-> arch/sh/boards/renesas/hs7751rvoip/setup.c:hs7751rvoip_setup()
-> arch/sh/boards/renesas/r7780rp/setup.c:highlander_setup()
-> arch/sh/boards/renesas/rts7751r2d/setup.c:rts7751r2d_setup()
-> arch/sh/boards/se/7343/setup.c:sh7343se_setup()
-> arch/sh/boards/se/770x/setup.c:smsc_setup()
-> arch/sh/boards/se/7722/setup.c:se7722_setup()
-> arch/sh/boards/se/7780/setup.c:se7780_setup()
-> arch/sh/boards/sh03/setup.c:sh03_setup()
-> arch/sh/boards/snapgear/setup.c:snapgear_setup()
-> arch/sh/boards/superh/microdev/setup.c:microdev_setup()

[ I didn't find these changes in Paul's latest sh-2.6(.22) tree,
but looks like the 2.6.23 dev tree is getting rid of ALIAS_MV.
But I suspect the (__initmv when !GENERIC && !UNKNOWN) .data ->
.init.text (__init) references being warned about here would still exist
there. ]

Janitorial patch attached resolves these bogus warnings by marking
the functions as __initmv too, but if this is wrong, feel free to NAK
it (and also suggest the correct solution :-)

---

sh_machine_vector structs in arch/sh/boards/ are marked __initmv
so that they go to the .machvec.init section (during setup_arch, all
but one would be discarded away) when SH_GENERIC || SH_UNKNOWN.

However, when !SH_GENERIC && !SH_UNKNOWN, __initmv is not
defined so these machine vector structures go to the .data section.

The .mv_setup member points to the setup function that is only ever
called during boot time, and hence the corresponding functions are
marked __init. But this causes modpost to (bogusly) warn about the
.data -> .init.text references during kernel build, thusly:

MODPOST vmlinux
WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
mismatch: reference to .init.text: (between 'mv_dreamcast' and
'systemasic_int')

So, mark the setup functions as __initmv too, to get rid of these
bogus warnings.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 arch/sh/boards/dreamcast/setup.c           |    2 +-
 arch/sh/boards/hp6xx/setup.c               |    2 +-
 arch/sh/boards/landisk/setup.c             |    2 +-
 arch/sh/boards/mpc1211/setup.c             |    2 +-
 arch/sh/boards/renesas/hs7751rvoip/setup.c |    2 +-
 arch/sh/boards/renesas/r7780rp/setup.c     |    2 +-
 arch/sh/boards/renesas/rts7751r2d/setup.c  |    2 +-
 arch/sh/boards/se/7343/setup.c             |    2 +-
 arch/sh/boards/se/770x/setup.c             |    4 ++--
 arch/sh/boards/se/7722/setup.c             |    2 +-
 arch/sh/boards/se/7780/setup.c             |    2 +-
 arch/sh/boards/sh03/setup.c                |    2 +-
 arch/sh/boards/snapgear/setup.c            |    2 +-
 arch/sh/boards/superh/microdev/setup.c     |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

------=_Part_131146_16281728.1182605234225
Content-Type: text/x-patch; name=sh-__init-to-__initmv.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3a4l976
Content-Disposition: attachment; filename="sh-__init-to-__initmv.patch"

ZGlmZiAtcnVOcCBjL2FyY2gvc2gvYm9hcmRzL2RyZWFtY2FzdC9zZXR1cC5jIGQvYXJjaC9zaC9i
b2FyZHMvZHJlYW1jYXN0L3NldHVwLmMKLS0tIGMvYXJjaC9zaC9ib2FyZHMvZHJlYW1jYXN0L3Nl
dHVwLmMJMjAwNy0wNC0yNiAwODozODozMi4wMDAwMDAwMDAgKzA1MzAKKysrIGQvYXJjaC9zaC9i
b2FyZHMvZHJlYW1jYXN0L3NldHVwLmMJMjAwNy0wNi0yMyAxODozNToyOC4wMDAwMDAwMDAgKzA1
MzAKQEAgLTM2LDcgKzM2LDcgQEAgZXh0ZXJuIGludCBzeXN0ZW1hc2ljX2lycV9kZW11eChpbnQp
Owogdm9pZCAqZHJlYW1jYXN0X2NvbnNpc3RlbnRfYWxsb2Moc3RydWN0IGRldmljZSAqLCBzaXpl
X3QsIGRtYV9hZGRyX3QgKiwgZ2ZwX3QpOwogaW50IGRyZWFtY2FzdF9jb25zaXN0ZW50X2ZyZWUo
c3RydWN0IGRldmljZSAqLCBzaXplX3QsIHZvaWQgKiwgZG1hX2FkZHJfdCk7CiAKLXN0YXRpYyB2
b2lkIF9faW5pdCBkcmVhbWNhc3Rfc2V0dXAoY2hhciAqKmNtZGxpbmVfcCkKK3N0YXRpYyB2b2lk
IF9faW5pdG12IGRyZWFtY2FzdF9zZXR1cChjaGFyICoqY21kbGluZV9wKQogewogCWludCBpOwog
CmRpZmYgLXJ1TnAgYy9hcmNoL3NoL2JvYXJkcy9ocDZ4eC9zZXR1cC5jIGQvYXJjaC9zaC9ib2Fy
ZHMvaHA2eHgvc2V0dXAuYwotLS0gYy9hcmNoL3NoL2JvYXJkcy9ocDZ4eC9zZXR1cC5jCTIwMDct
MDYtMjAgMTc6NTU6MzYuMDAwMDAwMDAwICswNTMwCisrKyBkL2FyY2gvc2gvYm9hcmRzL2hwNnh4
L3NldHVwLmMJMjAwNy0wNi0yMyAxODozNjoxMy4wMDAwMDAwMDAgKzA1MzAKQEAgLTU1LDcgKzU1
LDcgQEAgc3RhdGljIGludCBfX2luaXQgaHA2eHhfZGV2aWNlc19zZXR1cCh2bwogCXJldHVybiBw
bGF0Zm9ybV9hZGRfZGV2aWNlcyhocDZ4eF9kZXZpY2VzLCBBUlJBWV9TSVpFKGhwNnh4X2Rldmlj
ZXMpKTsKIH0KIAotc3RhdGljIHZvaWQgX19pbml0IGhwNnh4X3NldHVwKGNoYXIgKipjbWRsaW5l
X3ApCitzdGF0aWMgdm9pZCBfX2luaXRtdiBocDZ4eF9zZXR1cChjaGFyICoqY21kbGluZV9wKQog
ewogCXU4IHY4OwogCXUxNiB2OwpkaWZmIC1ydU5wIGMvYXJjaC9zaC9ib2FyZHMvbGFuZGlzay9z
ZXR1cC5jIGQvYXJjaC9zaC9ib2FyZHMvbGFuZGlzay9zZXR1cC5jCi0tLSBjL2FyY2gvc2gvYm9h
cmRzL2xhbmRpc2svc2V0dXAuYwkyMDA3LTA2LTIwIDE3OjU1OjM2LjAwMDAwMDAwMCArMDUzMAor
KysgZC9hcmNoL3NoL2JvYXJkcy9sYW5kaXNrL3NldHVwLmMJMjAwNy0wNi0yMyAxODozNjo1Ny4w
MDAwMDAwMDAgKzA1MzAKQEAgLTg1LDcgKzg1LDcgQEAgc3RhdGljIGludCBfX2luaXQgbGFuZGlz
a19kZXZpY2VzX3NldHVwKAogCiBfX2luaXRjYWxsKGxhbmRpc2tfZGV2aWNlc19zZXR1cCk7CiAK
LXN0YXRpYyB2b2lkIF9faW5pdCBsYW5kaXNrX3NldHVwKGNoYXIgKipjbWRsaW5lX3ApCitzdGF0
aWMgdm9pZCBfX2luaXRtdiBsYW5kaXNrX3NldHVwKGNoYXIgKipjbWRsaW5lX3ApCiB7CiAgICAg
ICAgIC8qIExFRCBPTiAqLwogCWN0cmxfb3V0YihjdHJsX2luYihQQV9MRUQpIHwgMHgwMywgUEFf
TEVEKTsKZGlmZiAtcnVOcCBjL2FyY2gvc2gvYm9hcmRzL21wYzEyMTEvc2V0dXAuYyBkL2FyY2gv
c2gvYm9hcmRzL21wYzEyMTEvc2V0dXAuYwotLS0gYy9hcmNoL3NoL2JvYXJkcy9tcGMxMjExL3Nl
dHVwLmMJMjAwNy0wNC0yNiAwODozODozMi4wMDAwMDAwMDAgKzA1MzAKKysrIGQvYXJjaC9zaC9i
b2FyZHMvbXBjMTIxMS9zZXR1cC5jCTIwMDctMDYtMjMgMTg6Mzc6MjYuMDAwMDAwMDAwICswNTMw
CkBAIC0zMTEsNyArMzExLDcgQEAgX19pbml0Y2FsbChtcGMxMjExX2RldmljZXNfc2V0dXApOwog
LyogYXJjaC9zaC9ib2FyZHMvbXBjMTIxMS9ydGMuYyAqLwogdm9pZCBtcGMxMjExX3RpbWVfaW5p
dCh2b2lkKTsKIAotc3RhdGljIHZvaWQgX19pbml0IG1wYzEyMTFfc2V0dXAoY2hhciAqKmNtZGxp
bmVfcCkKK3N0YXRpYyB2b2lkIF9faW5pdG12IG1wYzEyMTFfc2V0dXAoY2hhciAqKmNtZGxpbmVf
cCkKIHsKIAl1bnNpZ25lZCBjaGFyIHNwZF9idWZbMTI4XTsKIApkaWZmIC1ydU5wIGMvYXJjaC9z
aC9ib2FyZHMvcmVuZXNhcy9oczc3NTFydm9pcC9zZXR1cC5jIGQvYXJjaC9zaC9ib2FyZHMvcmVu
ZXNhcy9oczc3NTFydm9pcC9zZXR1cC5jCi0tLSBjL2FyY2gvc2gvYm9hcmRzL3JlbmVzYXMvaHM3
NzUxcnZvaXAvc2V0dXAuYwkyMDA3LTA0LTI2IDA4OjM4OjMyLjAwMDAwMDAwMCArMDUzMAorKysg
ZC9hcmNoL3NoL2JvYXJkcy9yZW5lc2FzL2hzNzc1MXJ2b2lwL3NldHVwLmMJMjAwNy0wNi0yMyAx
ODozNzo0OC4wMDAwMDAwMDAgKzA1MzAKQEAgLTc5LDcgKzc5LDcgQEAgc3RhdGljIGludCBfX2lu
aXQgaHM3NzUxcnZvaXBfY2ZfaW5pdCh2bwogLyoKICAqIEluaXRpYWxpemUgdGhlIGJvYXJkCiAg
Ki8KLXN0YXRpYyB2b2lkIF9faW5pdCBoczc3NTFydm9pcF9zZXR1cChjaGFyICoqY21kbGluZV9w
KQorc3RhdGljIHZvaWQgX19pbml0bXYgaHM3NzUxcnZvaXBfc2V0dXAoY2hhciAqKmNtZGxpbmVf
cCkKIHsKIAlkZXZpY2VfaW5pdGNhbGwoaHM3NzUxcnZvaXBfY2ZfaW5pdCk7CiAKZGlmZiAtcnVO
cCBjL2FyY2gvc2gvYm9hcmRzL3JlbmVzYXMvcjc3ODBycC9zZXR1cC5jIGQvYXJjaC9zaC9ib2Fy
ZHMvcmVuZXNhcy9yNzc4MHJwL3NldHVwLmMKLS0tIGMvYXJjaC9zaC9ib2FyZHMvcmVuZXNhcy9y
Nzc4MHJwL3NldHVwLmMJMjAwNy0wNi0yMCAxNzo1NTozNi4wMDAwMDAwMDAgKzA1MzAKKysrIGQv
YXJjaC9zaC9ib2FyZHMvcmVuZXNhcy9yNzc4MHJwL3NldHVwLmMJMjAwNy0wNi0yMyAxODozODox
Mi4wMDAwMDAwMDAgKzA1MzAKQEAgLTEyOCw3ICsxMjgsNyBAQCBzdGF0aWMgdm9pZCByNzc4MHJw
X3Bvd2VyX29mZih2b2lkKQogLyoKICAqIEluaXRpYWxpemUgdGhlIGJvYXJkCiAgKi8KLXN0YXRp
YyB2b2lkIF9faW5pdCBoaWdobGFuZGVyX3NldHVwKGNoYXIgKipjbWRsaW5lX3ApCitzdGF0aWMg
dm9pZCBfX2luaXRtdiBoaWdobGFuZGVyX3NldHVwKGNoYXIgKipjbWRsaW5lX3ApCiB7CiAJdTE2
IHZlciA9IGN0cmxfaW53KFBBX1ZFUlJFRyk7CiAJaW50IGk7CmRpZmYgLXJ1TnAgYy9hcmNoL3No
L2JvYXJkcy9yZW5lc2FzL3J0czc3NTFyMmQvc2V0dXAuYyBkL2FyY2gvc2gvYm9hcmRzL3JlbmVz
YXMvcnRzNzc1MXIyZC9zZXR1cC5jCi0tLSBjL2FyY2gvc2gvYm9hcmRzL3JlbmVzYXMvcnRzNzc1
MXIyZC9zZXR1cC5jCTIwMDctMDQtMjYgMDg6Mzg6MzIuMDAwMDAwMDAwICswNTMwCisrKyBkL2Fy
Y2gvc2gvYm9hcmRzL3JlbmVzYXMvcnRzNzc1MXIyZC9zZXR1cC5jCTIwMDctMDYtMjMgMTg6Mzg6
MzQuMDAwMDAwMDAwICswNTMwCkBAIC0xNTgsNyArMTU4LDcgQEAgc3RhdGljIHZvaWQgcnRzNzc1
MXIyZF9wb3dlcl9vZmYodm9pZCkKIC8qCiAgKiBJbml0aWFsaXplIHRoZSBib2FyZAogICovCi1z
dGF0aWMgdm9pZCBfX2luaXQgcnRzNzc1MXIyZF9zZXR1cChjaGFyICoqY21kbGluZV9wKQorc3Rh
dGljIHZvaWQgX19pbml0bXYgcnRzNzc1MXIyZF9zZXR1cChjaGFyICoqY21kbGluZV9wKQogewog
CXUxNiB2ZXIgPSBjdHJsX2ludyhQQV9WRVJSRUcpOwogCmRpZmYgLXJ1TnAgYy9hcmNoL3NoL2Jv
YXJkcy9zZS83MzQzL3NldHVwLmMgZC9hcmNoL3NoL2JvYXJkcy9zZS83MzQzL3NldHVwLmMKLS0t
IGMvYXJjaC9zaC9ib2FyZHMvc2UvNzM0My9zZXR1cC5jCTIwMDctMDQtMjYgMDg6Mzg6MzIuMDAw
MDAwMDAwICswNTMwCisrKyBkL2FyY2gvc2gvYm9hcmRzL3NlLzczNDMvc2V0dXAuYwkyMDA3LTA2
LTIzIDE4OjM5OjAyLjAwMDAwMDAwMCArMDUzMApAQCAtNTYsNyArNTYsNyBAQCBzdGF0aWMgaW50
IF9faW5pdCBzaDczNDNzZV9kZXZpY2VzX3NldHVwCiAJCQkJICAgIEFSUkFZX1NJWkUoc2g3MzQz
c2VfcGxhdGZvcm1fZGV2aWNlcykpOwogfQogCi1zdGF0aWMgdm9pZCBfX2luaXQgc2g3MzQzc2Vf
c2V0dXAoY2hhciAqKmNtZGxpbmVfcCkKK3N0YXRpYyB2b2lkIF9faW5pdG12IHNoNzM0M3NlX3Nl
dHVwKGNoYXIgKipjbWRsaW5lX3ApCiB7CiAJZGV2aWNlX2luaXRjYWxsKHNoNzM0M3NlX2Rldmlj
ZXNfc2V0dXApOwogfQpkaWZmIC1ydU5wIGMvYXJjaC9zaC9ib2FyZHMvc2UvNzcweC9zZXR1cC5j
IGQvYXJjaC9zaC9ib2FyZHMvc2UvNzcweC9zZXR1cC5jCi0tLSBjL2FyY2gvc2gvYm9hcmRzL3Nl
Lzc3MHgvc2V0dXAuYwkyMDA3LTA2LTIwIDE3OjU1OjM2LjAwMDAwMDAwMCArMDUzMAorKysgZC9h
cmNoL3NoL2JvYXJkcy9zZS83NzB4L3NldHVwLmMJMjAwNy0wNi0yMyAxODozOTo0Ni4wMDAwMDAw
MDAgKzA1MzAKQEAgLTE4LDE0ICsxOCwxNCBAQCB2b2lkIGluaXRfc2VfSVJRKHZvaWQpOwogLyoK
ICAqIENvbmZpZ3VyZSB0aGUgU3VwZXIgSS9PIGNoaXAKICAqLwotc3RhdGljIHZvaWQgX19pbml0
IHNtc2NfY29uZmlnKGludCBpbmRleCwgaW50IGRhdGEpCitzdGF0aWMgdm9pZCBfX2luaXRtdiBz
bXNjX2NvbmZpZyhpbnQgaW5kZXgsIGludCBkYXRhKQogewogCW91dGJfcChpbmRleCwgSU5ERVhf
UE9SVCk7CiAJb3V0Yl9wKGRhdGEsIERBVEFfUE9SVCk7CiB9CiAKIC8qIFhYWDogQW5vdGhlciBj
YW5kaWRhdGUgZm9yIGEgbW9yZSBnZW5lcmljIGNjaGlwIG1hY2hpbmUgdmVjdG9yICovCi1zdGF0
aWMgdm9pZCBfX2luaXQgc21zY19zZXR1cChjaGFyICoqY21kbGluZV9wKQorc3RhdGljIHZvaWQg
X19pbml0bXYgc21zY19zZXR1cChjaGFyICoqY21kbGluZV9wKQogewogCW91dGJfcChDT05GSUdf
RU5URVIsIENPTkZJR19QT1JUKTsKIAlvdXRiX3AoQ09ORklHX0VOVEVSLCBDT05GSUdfUE9SVCk7
CmRpZmYgLXJ1TnAgYy9hcmNoL3NoL2JvYXJkcy9zZS83NzIyL3NldHVwLmMgZC9hcmNoL3NoL2Jv
YXJkcy9zZS83NzIyL3NldHVwLmMKLS0tIGMvYXJjaC9zaC9ib2FyZHMvc2UvNzcyMi9zZXR1cC5j
CTIwMDctMDYtMjAgMTc6NTU6MzYuMDAwMDAwMDAwICswNTMwCisrKyBkL2FyY2gvc2gvYm9hcmRz
L3NlLzc3MjIvc2V0dXAuYwkyMDA3LTA2LTIzIDE4OjQwOjE1LjAwMDAwMDAwMCArMDUzMApAQCAt
MTAxLDcgKzEwMSw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHNlNzcyMl9kZXZpY2VzX3NldHVwKHYK
IH0KIGRldmljZV9pbml0Y2FsbChzZTc3MjJfZGV2aWNlc19zZXR1cCk7CiAKLXN0YXRpYyB2b2lk
IF9faW5pdCBzZTc3MjJfc2V0dXAoY2hhciAqKmNtZGxpbmVfcCkKK3N0YXRpYyB2b2lkIF9faW5p
dG12IHNlNzcyMl9zZXR1cChjaGFyICoqY21kbGluZV9wKQogewogCWN0cmxfb3V0dygweDAxMEQs
IEZQR0FfT1VUKTsgICAgLyogRlBHQSAqLwogCmRpZmYgLXJ1TnAgYy9hcmNoL3NoL2JvYXJkcy9z
ZS83NzgwL3NldHVwLmMgZC9hcmNoL3NoL2JvYXJkcy9zZS83NzgwL3NldHVwLmMKLS0tIGMvYXJj
aC9zaC9ib2FyZHMvc2UvNzc4MC9zZXR1cC5jCTIwMDctMDYtMjAgMTc6NTU6MzYuMDAwMDAwMDAw
ICswNTMwCisrKyBkL2FyY2gvc2gvYm9hcmRzL3NlLzc3ODAvc2V0dXAuYwkyMDA3LTA2LTIzIDE4
OjQwOjM2LjAwMDAwMDAwMCArMDUzMApAQCAtNzgsNyArNzgsNyBAQCBkZXZpY2VfaW5pdGNhbGwo
c2U3NzgwX2RldmljZXNfc2V0dXApOwogI2RlZmluZSBHUElPX1BNU0VMUiAgICAgIDB4RkZFQTAw
ODAKICNkZWZpbmUgR1BJT19QRUNSICAgICAgICAweEZGRUEwMDA4CiAKLXN0YXRpYyB2b2lkIF9f
aW5pdCBzZTc3ODBfc2V0dXAoY2hhciAqKmNtZGxpbmVfcCkKK3N0YXRpYyB2b2lkIF9faW5pdG12
IHNlNzc4MF9zZXR1cChjaGFyICoqY21kbGluZV9wKQogewogCS8qICJTSC1MaW51eCIgb24gTEVE
IERpc3BsYXkgKi8KIAljdHJsX291dHcoICdTJyAsIFBBX0xFRF9ESVNQICsgKERJU1BfU0VMMF9B
RERSIDw8IDEpICk7CmRpZmYgLXJ1TnAgYy9hcmNoL3NoL2JvYXJkcy9zaDAzL3NldHVwLmMgZC9h
cmNoL3NoL2JvYXJkcy9zaDAzL3NldHVwLmMKLS0tIGMvYXJjaC9zaC9ib2FyZHMvc2gwMy9zZXR1
cC5jCTIwMDctMDQtMjYgMDg6Mzg6MzIuMDAwMDAwMDAwICswNTMwCisrKyBkL2FyY2gvc2gvYm9h
cmRzL3NoMDMvc2V0dXAuYwkyMDA3LTA2LTIzIDE4OjQxOjU1LjAwMDAwMDAwMCArMDUzMApAQCAt
NDQsNyArNDQsNyBAQCBzdGF0aWMgdm9pZCBfX2lvbWVtICpzaDAzX2lvcG9ydF9tYXAodW5zCiAv
KiBhcmNoL3NoL2JvYXJkcy9zaDAzL3J0Yy5jICovCiB2b2lkIHNoMDNfdGltZV9pbml0KHZvaWQp
OwogCi1zdGF0aWMgdm9pZCBfX2luaXQgc2gwM19zZXR1cChjaGFyICoqY21kbGluZV9wKQorc3Rh
dGljIHZvaWQgX19pbml0bXYgc2gwM19zZXR1cChjaGFyICoqY21kbGluZV9wKQogewogCWJvYXJk
X3RpbWVfaW5pdCA9IHNoMDNfdGltZV9pbml0OwogfQpkaWZmIC1ydU5wIGMvYXJjaC9zaC9ib2Fy
ZHMvc25hcGdlYXIvc2V0dXAuYyBkL2FyY2gvc2gvYm9hcmRzL3NuYXBnZWFyL3NldHVwLmMKLS0t
IGMvYXJjaC9zaC9ib2FyZHMvc25hcGdlYXIvc2V0dXAuYwkyMDA3LTA0LTI2IDA4OjM4OjMyLjAw
MDAwMDAwMCArMDUzMAorKysgZC9hcmNoL3NoL2JvYXJkcy9zbmFwZ2Vhci9zZXR1cC5jCTIwMDct
MDYtMjMgMTg6NDI6NDEuMDAwMDAwMDAwICswNTMwCkBAIC04OCw3ICs4OCw3IEBAIHN0YXRpYyB2
b2lkIF9faW5pdCBpbml0X3NuYXBnZWFyX0lSUSh2b2kKIC8qCiAgKiBJbml0aWFsaXplIHRoZSBi
b2FyZAogICovCi1zdGF0aWMgdm9pZCBfX2luaXQgc25hcGdlYXJfc2V0dXAoY2hhciAqKmNtZGxp
bmVfcCkKK3N0YXRpYyB2b2lkIF9faW5pdG12IHNuYXBnZWFyX3NldHVwKGNoYXIgKipjbWRsaW5l
X3ApCiB7CiAJYm9hcmRfdGltZV9pbml0ID0gc2VjdXJlZWRnZTU0MTBfcnRjX2luaXQ7CiB9CmRp
ZmYgLXJ1TnAgYy9hcmNoL3NoL2JvYXJkcy9zdXBlcmgvbWljcm9kZXYvc2V0dXAuYyBkL2FyY2gv
c2gvYm9hcmRzL3N1cGVyaC9taWNyb2Rldi9zZXR1cC5jCi0tLSBjL2FyY2gvc2gvYm9hcmRzL3N1
cGVyaC9taWNyb2Rldi9zZXR1cC5jCTIwMDctMDYtMjAgMTc6NTU6MzYuMDAwMDAwMDAwICswNTMw
CisrKyBkL2FyY2gvc2gvYm9hcmRzL3N1cGVyaC9taWNyb2Rldi9zZXR1cC5jCTIwMDctMDYtMjMg
MTg6NDM6NTEuMDAwMDAwMDAwICswNTMwCkBAIC0zNTUsNyArMzU1LDcgQEAgc3RhdGljIGludCBf
X2luaXQgc21zY19zdXBlcmlvX3NldHVwKHZvaQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgdm9p
ZCBfX2luaXQgbWljcm9kZXZfc2V0dXAoY2hhciAqKmNtZGxpbmVfcCkKK3N0YXRpYyB2b2lkIF9f
aW5pdG12IG1pY3JvZGV2X3NldHVwKGNoYXIgKipjbWRsaW5lX3ApCiB7CiAJaW50ICogY29uc3Qg
ZnBnYVJldmlzaW9uUmVnaXN0ZXIgPSAoaW50KikoTUlDUk9ERVZfRlBHQV9HUF9CQVNFICsgMHg4
dWwpOwogCWNvbnN0IGludCBmcGdhUmV2aXNpb24gPSAqZnBnYVJldmlzaW9uUmVnaXN0ZXI7Cg==

------=_Part_131146_16281728.1182605234225--

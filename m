Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXGRPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXGRPQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXGRPQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:16:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:33705 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbXGRPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=PwT+JGVCCRhqGP5m8Y88NpwKb+tmKozngr9AAWfVMaeSIuy8mfOoyuEaldqv1f47KLo+JF5h0eFsZ2d2KjhjETRVIXaKblz8UXMmqSGMReClLTZwettPAV7cgkJ0bV13FKRmsNY1E1Tb7IQ33aQivz4dRFJt+q8d4ifsRycxZl0=
Message-ID: <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
Date: Wed, 18 Jul 2007 20:46:35 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <469E2A68.6010307@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_87019_32563363.1184771795693"
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <469B61C8.8010902@googlemail.com>
	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>
	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_87019_32563363.1184771795693
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> Satyam Sharma wrote:
> > On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> >> There is a subtle bug in sysfs_create_link() failure path.  When
> >> symlink creation fails because there's already a node with the same
> >> name, the target sysfs_dirent is put twice - once by failure path of
> >> sysfs_create_link() and once more when the symlink is released.
> >
> > The "symlink" is released? But the creation of the symlink is
> > precisely what failed here ... did it not?
> >
> >> Fix it by making only the symlink node responsible for putting
> >> target_sd.
> >
> > And again ... the changelog sounds confusing indeed, perhaps I'm
> > not familiar enough with sysfs symlink-related terminology/semantics.
> > Care to elaborate?
> >
> >>         sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
> >>         if (!sd)
> >>                 goto out_put;
> >> +
> >>         sd->s_elem.symlink.target_sd = target_sd;
> >> +       target_sd = NULL;       /* reference is now owned by the
> >> symlink */
> >
> > Wow. This looks like a very mysterious way to fix a mysterious bug :-)
> > BTW I just looked over at sysfs_create_link() and ... it looks quite ...
> > unnecessarily complicated/obfuscated ...
>
> Well, I dunno.  Probably my taste just sucks.  Please feel free to
> submit patches and/or suggest better ideas.

OK, for example:

sysfs_find_dirent() -- to check for -EEXIST -- should be called
*before* we create the new dentry for the to-be-created symlink
in the first place. [ It's weird to grab a reference on the target
for ourselves (and in fact even allocate the new dirent for the
to-be-created symlink) and /then/ check for erroneous usage,
and then go about undoing all that we should never have done
at all. ] So this test could, and should, be made earlier, IMHO.

And some similar others ... so attached (sorry, Gmail web
interface) please find an attempt to make sysfs_create_link look
a trifle more like what it should look like, IMHO. The code cleanup
also leads to fewer LOC, smaller kernel image (lesser by 308 bytes),
and even speeding up the no-error common case of this function,
apart from the obvious readability benefits ... it's diffed on _top_ of
your bugfix here, but not the other patch. [ Compile-tested only. ]

BTW this bug was clearly *very* subtle. I spent a couple of hours or
so yesterday night on the same resulting use-after-free (which actually
gets triggered in a completely different codepath, and which is
completely temporally disconnected from its actual cause over here).

Thanks,
Satyam

------=_Part_87019_32563363.1184771795693
Content-Type: text/plain; name=sanitize-sysfs_create_link-new.txt; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f49ynihz
Content-Disposition: attachment; filename="sanitize-sysfs_create_link-new.txt"

U2lnbmVkLW9mZi1ieTogU2F0eWFtIFNoYXJtYSA8c3NhdHlhbUBjc2UuaWl0ay5hYy5pbj4NCg0K
LS0tDQoNCiBmcy9zeXNmcy9zeW1saW5rLmMgfCAgIDc0ICsrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZXMgY2hhbmdlZCwgMzMgaW5zZXJ0
aW9ucygrKSwgNDEgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9mcy9zeXNmcy9zeW1saW5r
LmMgYi9mcy9zeXNmcy9zeW1saW5rLmMNCmluZGV4IGQwNTZlOTYuLmJlYzQ3N2QgMTAwNjQ0DQot
LS0gYS9mcy9zeXNmcy9zeW1saW5rLmMNCisrKyBiL2ZzL3N5c2ZzL3N5bWxpbmsuYw0KQEAgLTUw
LDY1ICs1MCw1NyBAQCBzdGF0aWMgdm9pZCBmaWxsX29iamVjdF9wYXRoKHN0cnVjdCBzeXNmc19k
aXJlbnQgKnNkLCBjaGFyICpidWZmZXIsIGludCBsZW5ndGgpDQogICoJQHRhcmdldDoJb2JqZWN0
IHdlJ3JlIHBvaW50aW5nIHRvLg0KICAqCUBuYW1lOgkJbmFtZSBvZiB0aGUgc3ltbGluay4NCiAg
Ki8NCi1pbnQgc3lzZnNfY3JlYXRlX2xpbmsoc3RydWN0IGtvYmplY3QgKiBrb2JqLCBzdHJ1Y3Qg
a29iamVjdCAqIHRhcmdldCwgY29uc3QgY2hhciAqIG5hbWUpDQoraW50IHN5c2ZzX2NyZWF0ZV9s
aW5rKHN0cnVjdCBrb2JqZWN0ICprb2JqLCBzdHJ1Y3Qga29iamVjdCAqdGFyZ2V0LCBjb25zdCBj
aGFyICpuYW1lKQ0KIHsNCi0Jc3RydWN0IHN5c2ZzX2RpcmVudCAqcGFyZW50X3NkID0gTlVMTDsN
Ci0Jc3RydWN0IHN5c2ZzX2RpcmVudCAqdGFyZ2V0X3NkID0gTlVMTDsNCi0Jc3RydWN0IHN5c2Zz
X2RpcmVudCAqc2QgPSBOVUxMOw0KKwlzdHJ1Y3Qgc3lzZnNfZGlyZW50ICpwYXJlbnRfc2Q7DQor
CXN0cnVjdCBzeXNmc19kaXJlbnQgKnNkOw0KIAlzdHJ1Y3Qgc3lzZnNfYWRkcm1fY3h0IGFjeHQ7
DQotCWludCBlcnJvcjsNCisJaW50IGVycm9yID0gMDsNCiANCiAJQlVHX09OKCFuYW1lKTsNCiAN
Ci0JaWYgKCFrb2JqKSB7DQotCQlpZiAoc3lzZnNfbW91bnQgJiYgc3lzZnNfbW91bnQtPm1udF9z
YikNCi0JCQlwYXJlbnRfc2QgPSBzeXNmc19tb3VudC0+bW50X3NiLT5zX3Jvb3QtPmRfZnNkYXRh
Ow0KLQl9IGVsc2UNCisJaWYgKGtvYmopDQogCQlwYXJlbnRfc2QgPSBrb2JqLT5zZDsNCisJZWxz
ZSBpZiAoc3lzZnNfbW91bnQgJiYgc3lzZnNfbW91bnQtPm1udF9zYikNCisJCXBhcmVudF9zZCA9
IHN5c2ZzX21vdW50LT5tbnRfc2ItPnNfcm9vdC0+ZF9mc2RhdGE7DQorCWVsc2Ugew0KKwkJZXJy
b3IgPSAtRUZBVUxUOw0KKwkJZ290byBvdXQ7DQorCX0NCiANCi0JZXJyb3IgPSAtRUZBVUxUOw0K
LQlpZiAoIXBhcmVudF9zZCkNCi0JCWdvdG8gb3V0X3B1dDsNCisJaWYgKHN5c2ZzX2ZpbmRfZGly
ZW50KHBhcmVudF9zZCwgbmFtZSkpIHsNCisJCWVycm9yID0gLUVFWElTVDsNCisJCWdvdG8gb3V0
Ow0KKwl9DQorDQorCXNkID0gc3lzZnNfbmV3X2RpcmVudChuYW1lLCBTX0lGTE5LIHwgU19JUldY
VUdPLCBTWVNGU19LT0JKX0xJTkspOw0KKwlpZiAoIXNkKSB7DQorCQllcnJvciA9IC1FTk9NRU07
DQorCQlnb3RvIG91dDsNCisJfQ0KIA0KIAkvKiB0YXJnZXQtPnNkIGNhbiBnbyBhd2F5IGJlbmVh
dGggdXMgYnV0IGlzIHByb3RlY3RlZCB3aXRoDQotCSAqIHN5c2ZzX2Fzc29jX2xvY2suICBGZXRj
aCB0YXJnZXRfc2QgZnJvbSBpdC4NCisJICogc3lzZnNfYXNzb2NfbG9jay4gR3JhYiB1cyBhIHJl
ZmVyZW5jZSBvbiBpdC4NCiAJICovDQogCXNwaW5fbG9jaygmc3lzZnNfYXNzb2NfbG9jayk7DQog
CWlmICh0YXJnZXQtPnNkKQ0KLQkJdGFyZ2V0X3NkID0gc3lzZnNfZ2V0KHRhcmdldC0+c2QpOw0K
KwkJc2QtPnNfZWxlbS5zeW1saW5rLnRhcmdldF9zZCA9IHN5c2ZzX2dldCh0YXJnZXQtPnNkKTsN
CisJZWxzZSB7DQorCQlzcGluX3VubG9jaygmc3lzZnNfYXNzb2NfbG9jayk7DQorCQlzeXNmc19w
dXQoc2QpOw0KKwkJZXJyb3IgPSAtRU5PRU5UOw0KKwkJZ290byBvdXQ7DQorCX0NCiAJc3Bpbl91
bmxvY2soJnN5c2ZzX2Fzc29jX2xvY2spOw0KIA0KLQllcnJvciA9IC1FTk9FTlQ7DQotCWlmICgh
dGFyZ2V0X3NkKQ0KLQkJZ290byBvdXRfcHV0Ow0KLQ0KLQllcnJvciA9IC1FTk9NRU07DQotCXNk
ID0gc3lzZnNfbmV3X2RpcmVudChuYW1lLCBTX0lGTE5LfFNfSVJXWFVHTywgU1lTRlNfS09CSl9M
SU5LKTsNCi0JaWYgKCFzZCkNCi0JCWdvdG8gb3V0X3B1dDsNCi0NCi0Jc2QtPnNfZWxlbS5zeW1s
aW5rLnRhcmdldF9zZCA9IHRhcmdldF9zZDsNCi0JdGFyZ2V0X3NkID0gTlVMTDsJLyogcmVmZXJl
bmNlIGlzIG5vdyBvd25lZCBieSB0aGUgc3ltbGluayAqLw0KLQ0KIAlzeXNmc19hZGRybV9zdGFy
dCgmYWN4dCwgcGFyZW50X3NkKTsNCi0NCi0JaWYgKCFzeXNmc19maW5kX2RpcmVudChwYXJlbnRf
c2QsIG5hbWUpKSB7DQotCQlzeXNmc19hZGRfb25lKCZhY3h0LCBzZCk7DQotCQlzeXNmc19saW5r
X3NpYmxpbmcoc2QpOw0KLQl9DQotDQotCWlmIChzeXNmc19hZGRybV9maW5pc2goJmFjeHQpKQ0K
LQkJcmV0dXJuIDA7DQotDQotCWVycm9yID0gLUVFWElTVDsNCi0JLyogZmFsbCB0aHJvdWdoICov
DQotIG91dF9wdXQ6DQotCXN5c2ZzX3B1dCh0YXJnZXRfc2QpOw0KLQlzeXNmc19wdXQoc2QpOw0K
KwlzeXNmc19hZGRfb25lKCZhY3h0LCBzZCk7DQorCXN5c2ZzX2xpbmtfc2libGluZyhzZCk7DQor
CXN5c2ZzX2FkZHJtX2ZpbmlzaCgmYWN4dCk7DQorb3V0Og0KIAlyZXR1cm4gZXJyb3I7DQogfQ0K
IA0KLQ0KIC8qKg0KICAqCXN5c2ZzX3JlbW92ZV9saW5rIC0gcmVtb3ZlIHN5bWxpbmsgaW4gb2Jq
ZWN0J3MgZGlyZWN0b3J5Lg0KICAqCUBrb2JqOglvYmplY3Qgd2UncmUgYWN0aW5nIGZvci4NCg==

------=_Part_87019_32563363.1184771795693--

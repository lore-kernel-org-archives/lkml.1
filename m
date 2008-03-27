Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYC0VMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYC0VMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYC0VMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:12:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:56465 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYC0VMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Ldp9P8neQGchURLPXxzZyMpFEjOxSebBHpMLljHglv+8nnh+gd4kaKXg7eNhKv71kE/RMa2dT8wEUkXe2uBDOIs+R/PbZsbx26gQFR/qm3aqjG/NM1n1VbXNpMiYZeI0DMrdzsRuAq5h8XRHiPW5jvpUwjuyHaii5H053tgJLG0=
Message-ID: <170fa0d20803271412i6d7dd81ax41e0f77339b5def7@mail.gmail.com>
Date: Thu, 27 Mar 2008 17:12:37 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: nbd: Oops because nbd doesn't prevent NBD_CLEAR_SOCK while sock_xmit() is working on a receive
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <170fa0d20803270621k7723ae47n337011beafe87cdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8488_8567028.1206652357642"
References: <170fa0d20803261143s1ab258b2ra470c158ac5744a@mail.gmail.com>
	 <47EB94AB.6090608@steeleye.com>
	 <170fa0d20803270621k7723ae47n337011beafe87cdb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8488_8567028.1206652357642
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Mar 27, 2008 at 9:21 AM, Mike Snitzer <snitzer@gmail.com> wrote:
> On Thu, Mar 27, 2008 at 8:35 AM, Paul Clements
>  <paul.clements@steeleye.com> wrote:
>  > Mike Snitzer wrote:
>  >
>  >  > In practice this looks like:
>  >  >
>  >  > nbd1: NBD_DISCONNECT
>  >  > nbd1: Send control failed (result -32)
>  >  > end_request: I/O error, dev nbd1, sector 0
>  >  > end_request: I/O error, dev nbd1, sector 8032264
>  >  > md: super_written gets error=-5, uptodate=0
>  >  > raid1: Disk failure on nbd1, disabling device.
>  >  >         Operation continuing on 1 devices
>  >  > Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
>  >  >  [<ffffffff88b1e125>] :nbd:sock_xmit+0x9d/0x301
>  >
>  >  > The fact that sock_xmit() in receive mode is unprotected seems to be
>  >  > the WHY a NULL pointer is possible; but I'm still trying to identify
>  >  > the HOW.
>  >
>  >  Do you know who is setting the socket NULL? Is it already NULL when you
>  >  get to this point? Is it the nbd-client -d? Is it the original
>  >  nbd-client/kernel that does it? Figuring that out would help narrow down
>  >  the cause.
>
>  I believe that NBD_CLEAR_SOCK from 'nbd-client -d' sets it to NULL.
>  lo->sock is already NULL on entry to sock_xmit().
>
>  So simply checking if the sock_xmit's 'sock' is NULL _should_ avoid
>  any possibility of a NULL pointer Oops because sock can't be !NULL
>  after the negative check (because of the sock = lo->sock assignment).
>  That is, unless I'm missing somewhere in the rest of the kernel (not
>  nbd) that would take action to set a socket to NULL?
>
>  The attached patch seems reasonable.  I'll be testing today to verify
>  it fixes the problem.

The nbd_sock_xmit_oops.patch from my previous email does fix this issue.

I verified this by making the race window wider with the attached patch.

The sequence to hit this race (with a patched nbd) is:

# insmod ./nbd_exposed.ko
# nbd-client 192.168.114.152 9011 /dev/nbd1
Negotiation: ..size = 3148739KB
bs=1024, sz=3148739
# dd if=/dev/nbd1 of=/dev/null &
[ NOTE: wait to see "sleeping 30s before recv in sock_xmit" in the syslog ]
# nbd-client -d /dev/nbd1

In the system log you'll see something like:

nbd: registered device at major 43
nbd1:
nbd1: sleeping 30s before recv in sock_xmit
nbd1: NBD_DISCONNECT
nbd1: sleeping 30s after setting sock to NULL in NBD_CLEAR_SOCK
nbd1: sleeping 30s before recv in sock_xmit
Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
 [<ffffffff883a917c>] :nbd:sock_xmit+0xf0/0x33e
PGD 141b52067 PUD 144eaf067 PMD 0
Oops: 0000 [1] SMP
...

With the nbd_sock_xmit_oops.patch applied this Oops no longer happens.
 I think my original patch's use of EINVAL should be changed to EIO.
Any other comments on the fix are welcome.

Paul, would you like an updated patch that you push upstream?  Or
should I just submit the patch and Cc: you?

Mike

------=_Part_8488_8567028.1206652357642
Content-Type: text/x-patch; name=nbd_sock_xmit_expose_race.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_febsyf590
Content-Disposition: attachment; filename=nbd_sock_xmit_expose_race.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbmJkLmMgYi9kcml2ZXJzL2Jsb2NrL25iZC5jCmlu
ZGV4IGI1M2ZkYjAuLjM4Mzk3ZDQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYmxvY2svbmJkLmMKKysr
IGIvZHJpdmVycy9ibG9jay9uYmQuYwpAQCAtMTU4LDYgKzE1OCwxNCBAQCBzdGF0aWMgaW50IHNv
Y2tfeG1pdChzdHJ1Y3QgbmJkX2RldmljZSAqbG8sIGludCBzZW5kLCB2b2lkICpidWYsIGludCBz
aXplLAogCXNpZ2luaXRzZXRpbnYoJmJsb2NrZWQsIHNpZ21hc2soU0lHS0lMTCkpOwogCXNpZ3By
b2NtYXNrKFNJR19TRVRNQVNLLCAmYmxvY2tlZCwgJm9sZHNldCk7CiAKKwlpZiAoIXNlbmQpIHsK
KwkJLyogc2xlZXAgMzBzIHRvIGV4cG9zZSByYWNlIHdpdGggJ25iZC1jbGllbnQgLWQnICovCisJ
CXByaW50ayhLRVJOX1dBUk5JTkcgIiVzOiBzbGVlcGluZyAzMHMgYmVmb3JlIHJlY3YgaW4gc29j
a194bWl0XG4iLAorCQkgICAgICAgbG8tPmRpc2stPmRpc2tfbmFtZSk7CisJCXNldF9jdXJyZW50
X3N0YXRlKFRBU0tfSU5URVJSVVBUSUJMRSk7CisJCXNjaGVkdWxlX3RpbWVvdXQobXNlY3NfdG9f
amlmZmllcygzMDAwMCkpOworCX0KKwkKIAlkbyB7CiAJCXNvY2stPnNrLT5za19hbGxvY2F0aW9u
ID0gR0ZQX05PSU87CiAJCWlvdi5pb3ZfYmFzZSA9IGJ1ZjsKQEAgLTU1MCw3ICs1NTgsMTQgQEAg
c3RhdGljIGludCBuYmRfaW9jdGwoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZp
bGUsCiAJY2FzZSBOQkRfQ0xFQVJfU09DSzoKIAkJZXJyb3IgPSAwOwogCQltdXRleF9sb2NrKCZs
by0+dHhfbG9jayk7Ci0JCWxvLT5zb2NrID0gTlVMTDsKKwkJaWYgKGxvLT5zb2NrKSB7CisJCQls
by0+c29jayA9IE5VTEw7CisJCQkvKiBzbGVlcCAzMHMgdG8gZXhwb3NlIHJhY2Ugd2l0aCBzb2Nr
X3htaXQgKi8KKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgIiVzOiBzbGVlcGluZyAzMHMgYWZ0ZXIg
c2V0dGluZyBzb2NrIHRvIE5VTEwgaW4gTkJEX0NMRUFSX1NPQ0tcbiIsCisJCQkgICAgICAgbG8t
PmRpc2stPmRpc2tfbmFtZSk7CisJCQlzZXRfY3VycmVudF9zdGF0ZShUQVNLX0lOVEVSUlVQVElC
TEUpOworCQkJc2NoZWR1bGVfdGltZW91dChtc2Vjc190b19qaWZmaWVzKDMwMDAwKSk7CisJCX0K
IAkJbXV0ZXhfdW5sb2NrKCZsby0+dHhfbG9jayk7CiAJCWZpbGUgPSBsby0+ZmlsZTsKIAkJbG8t
PmZpbGUgPSBOVUxMOwo=
------=_Part_8488_8567028.1206652357642--

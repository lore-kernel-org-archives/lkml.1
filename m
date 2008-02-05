Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbYBEXRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbYBEXRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbYBEXRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:17:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:54541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755957AbYBEXRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:17:06 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mel@csn.ul.ie
Content-Type: multipart/mixed; boundary="========GMX220631202253421230786"
Date: Wed, 06 Feb 2008 00:17:01 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <1202169996.7079.20.camel@pasglop>
Message-ID: <20080205231701.220630@gmx.net>
MIME-Version: 1.0
References: <20080201184254.174020@gmx.net>	 <20080201191119.GI18688@csn.ul.ie>
  <20080201200518.174050@gmx.net> <1202169996.7079.20.camel@pasglop>
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
To: benh@kernel.crashing.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/FNwoO8MbFS0CAm9ULyfF2F2pS5ZtEruSFRFIMo3
 dvsws0Yj4bVOnxlTA536K6T5cptgoLjZfsOg== 
X-GMX-UID: DIfddBtjODB6VkRrLmRMmaI9Ji9SWhIi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX220631202253421230786
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

-------- Original-Nachricht --------
> Datum: Tue, 05 Feb 2008 11:06:36 +1100
> Von: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
> Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my machine

> 
> On Fri, 2008-02-01 at 21:05 +0100, Gerhard Pircher wrote:
> > -------- Original-Nachricht --------
> > > Datum: Fri, 1 Feb 2008 19:11:19 +0000
> > > Von: Mel Gorman <mel@csn.ul.ie>
> > > An: Gerhard Pircher <gerhard_pircher@gmx.net>
> > > CC: linux-kernel@vger.kernel.org
> > > Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my
> machine
> > 
> > > With this patch, early boot would use pages from lower PFNs. Without
> > > the patch, it would use memory from higher PFNs. That is the only
> > > real difference.
> > > 
> > > 1. Is there any chance that all of your memory is not being properly
> > >    initialised?
> > Do you mean uninitialized hardware? That shouldn't be a problem, since
> > older kernels (e.g. 2.6.19 with platform patches for arch/ppc) are
> > running fine.
> 
> No, it looks more to me like you aren't properly defining the available
> memory somewhere, or along those lines. Are you using CONFIG_HIGHMEM ? I
> think there have been some issues until recent patches from Kumar, if
> you try to reserve memory in the highmem region (though that may not be
> your problem).
As far as I can see, the U-boot bootwrapper enters the correct size for
the available system memory. Also the memory zone initialization looks
reasonable to me (768 MB in DMA zone and 768 MB in HIGHMEM zone - it's a
G4 machine with 1.5GB RAM).
I compiled kernels (v2.6.24) with and without highmem. The attached
logfiles (kernel-[no]highmem.log) indicate that this doesn't seem to be
the problem.
The kernel boots fine until loading INIT, if it is compiled with this
patch (IIRC commited for 2.6.24-rc2, reverted for 2.6.24):
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5adc5be7cd1bcef6bb64f5255d2a33f20a3cf5be
(see logfile kernel-pages_at_lower_pfns.log)

> Or maybe you are colliding with some of the non-coherent hacks ?
Yes, the AmigaOne platform code makes use of the non coherent DMA
implementation, but that seems to be working just fine. I compiled a
kernel without non coherent DMA support and it died during the boot
process, too.

> > > Could you try booting with 16MB less memory using mem=?
> > > I started the kernel with 512MB RAM (mem=496) and 1.5GB (mem=1520).
> > > The kernel oopes in both cases with a "Unable to handle kernel
> > > paging request for data address 0xbffff000", followed by a "Oops:
> > > kernel access of bad area, sig 11" message. The end of the stack
> > > trace shows the start_here() function.
> Have you tried DEBUG_PAGEALLOC ? It might fault earlier which might give
> us better informations. Also, a stactrace from the oops might be useful,
> along with a copy of your device-tree.
Yes, I attached the log file for a kernel compiled with DEBUG_PAGEALLOC.
But I'm afraid it doesn't contain useful information, because the log is
even more distorted.

The oops only happend when using the "mem" boot option. The
kernel-oopsmemoption.log attachment should show the stack trace.

I really wonder why the kernel log buffer gets distorted. I only
experienced this with newer kernels (>2.6.23). Note that I haven't tested
older versions (2.6.20-2.6.22).

I included the AmigaOne platform patch (device tree, setup code). The
platform setup code clears the CPU_FTR_NEED_COHERENT flag for G4 cpus and
disables the L2 cache prefetch to workaround a cpu and northbridge bug.
This workaround worked with all 2.6.x kernels so far.

Thanks!

Gerhard
-- 
Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! 
Ideal für Modem und ISDN: http://www.gmx.net/de/go/smartsurfer

--========GMX220631202253421230786
Content-Type: application/octet-stream; name="kernel-highmem.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="kernel-highmem.log"

PDY+VXNpbmcgQW1pZ2FPbmUgbWFjaGluZSBkZXNjcmlwdGlvbgo8ND5Ub3RhbCBtZW1vcnkgPSAx
NTM2TUI7IHVzaW5nIDQwOTZrQiBmb3IgaGFzaCB0YWJsZSAoYXQgY2ZjMDAwMDApCjw1PkxpbnV4
IHZlcnNpb24gMi42LjI0IChnZXJpQGVhcnRoKSAoZ2NjIHZlcnNpb24gNC4xLjIgMjAwNjExMTUg
KHByZXJlbGVhc2UpIChEZWJpYW4gNC4xLjEtMjEpKSAjOCBTdW4gRmViIDMgMjI6MTQ6NTEgQ0VU
IDIwMDgKPDc+Rm91bmQgbGVnYWN5IHNlcmlhbCBwb3J0IDAgZm9yIC9wY2lAODAwMDAwMDAvaXNh
QDcvc2VyaWFsQDJmOAo8Nz4gIHBvcnQ9MmY4LCB0YWRkcj1mZTAwMDJmOCwgaXJxPTAsIGNsaz0x
ODQzMjAwLCBzcGVlZD0wCjw3PkZvdW5kIGxlZ2FjeSBzZXJpYWwgcG9ydCAxIGZvciAvcGNpQDgw
MDAwMDAwL2lzYUA3L3NlcmlhbEAzZjgKPDc+ICBwb3J0PTNmOCwgdGFkZHI9ZmUwMDAzZjgsIGly
cT0wLCBjbGs9MTg0MzIwMCwgc3BlZWQ9MAo8Nj5jb25zb2xlIFt1ZGJnMF0gZW5hYmxlZAo8Nz5F
bnRlcmluZyBhZGRfYWN0aXZlX3JhbmdlKDAsIDAsIDM5MzIxNikgMCBlbnRyaWVzIG9mIDI1NiB1
c2VkCjw0PkFtaWdhT25lIGwyY3IgOiBMMiBjYWNoZSB3YXMgbm90IGFjdGl2ZSwgYWN0aXZhdGlu
Zy4KPDc+VG9wIG9mIFJBTTogMHg2MDAwMDAwMCwgVG90YWwgUkFNOiAweDYwMDAwMDAwCjw3Pk1l
bW9yeSBob2xlIHNpemU6IDBNQgo8ND5ab25lIFBGTiByYW5nZXM6Cjw0PiAgRE1BICAgICAgICAg
ICAgIDAgLT4gICAxOTY2MDgKPDQ+ICBOb3JtYWwgICAgIDE5NjYwOCAtPiAgIDE5NjYwOAo8ND4g
IEhpZ2hNZW0gICAgMTk2NjA4IC0+ICAgMzkzMjE2Cjw0Pk1vdmFibGUgem9uZSBzdGFydCBQRk4g
Zm9yIGVhY2ggbm9kZQo8ND5lYXJseV9ub2RlX21hcFsxXSBhY3RpdmUgUEZOIHJhbmdlcwo8ND4g
ICAgMDogICAgICAgIDAgLT4gICAzOTMyMTYKPDc+T24gbm9kZSAwIHRvdGFscGFnZXM6IDM5MzIx
Ngo8Nz4gIERNQSB6b25lOiAxNTM2IHBhZ2VzIHVzZWQgZm9yIG1lbW1hcAo8Nz4gIERNQSB6b25l
OiAwIHBhZ2VzIHJlc2VydmVkCjw3PiAgRE1BIHpvbmU6IDE5NTA3MiBwYWdlcywgTElGTyBiYXRj
aDozMQo8Nz4gIE5vcm1hbCB6b25lOiAwIHBhZ2VzIHVzZWQgZm9yIG1lbW1hcAo8Nz4gIEhpZ2hN
ZW0gem9uZTogMTUzNiBwYWdlcyB1c2VkIGZvciBtZW1tYXAKPDc+ICBIaWdoTWVtIHpvbmU6IDE5
NTA3MiBwYWdlcywgTElGTyBiYXRjaDozMQo8Nz4gIE1vdmFibGUgem9uZTogMCBwYWdlcyB1c2Vk
IGZvciBtZW1tYXAKPDQ+QnVpbHQgMSB6b25lbGlzdHMgaW4gWm9uZSBvcmRlciwgbW9iaWxpdHkg
Z3JvdXBpbmcgb24uICBUb3RhbCBwYWdlczogMzkwMTQ0Cjw1Pktlcm5lbCBjb21tYW5kIGxpbmU6
IGluaXRjYWxsX2RlYnVnIGRyaXZlcl9kZWJ1ZyBkZWJ1ZyByb290PS9kZXYvaGRhMTEgY29uc29s
ZT10dHlTMCwxMTUyMDBuOHIgY29uc29sZT10dHkwIGlkZTA9YXRhNjYgaWRlMT1hdGE2Ngo8Nj5p
ZGVfc2V0dXA6IGlkZTA9YXRhNjYgLS0gT0JTT0xFVEUgT1BUSU9OLCBXSUxMIEJFIFJFTU9WRUQg
U09PTiEKPDY+aWRlX3NldHVwOiBpZGUxPWF0YTY2IC0tIE9CU09MRVRFIE9QVElPTiwgV0lMTCBC
RSBSRU1PVkVEIFNPT04hCjw2Pmk4MjU5IGxlZ2FjeSBpbnRlcnJ1cHQgY29udHJvbGxlciBpbml0
aWFsaXplZAo8ND5QSUQgaGFzaCB0YWJsZSBlbnRyaWVzOiA0MDk2IChvcmRlcjogMTIsIDE2Mzg0
IGJ5dGVzKQo8Nz50aW1lX2luaXQ6IGRlY3JlbWVudGVyIGZyZXF1ZW5jeSA9IDMzLjMzMzMzMyBN
SHoKPDc+dGltZV9pbml0OiBwcm9jZXNzb3IgZnJlcXVlbmN5ICAgPSA4MDAuMDAwMDAwIE1Iego8
Nj5jbG9ja3NvdXJjZTogdGltZWJhc2UgbXVsdFs3ODAwMDAxXSBzaGlmdFsyMl0gcmVnaXN0ZXJl
ZAo8Nz5jbG9ja2V2ZW50OiBkZWNyZW1lbnRlciBtdWx0Wzg4OF0gc2hpZnRbMTZdIGNwdVswXQo8
ND5Db25zb2xlOiBjb2xvdXIgZHVtbXkgZGV2aWNlIDgweDI1Cjw2PmNvbnNvbGUgaGFuZG92ZXI6
IGJvb3QgW3VkYmcwXSAtPiByZWFsIFt0dHkwXQo8Nj5EZW50cnkgY2FjaGUgaGFzaCB0YWJsZSBl
bnRyaWVzOiAxMzEwNzIgKG9yZGVyOiA3LCA1MjQyODggYnl0ZXMpCjw2Pklub2RlLWNhY2hlIGhh
c2ggdGFibGUgZW50cmllczogNjU1MzYgKG9yZGVyOiA2LCAyNjIxNDQgYnl0ZXMpCjw3PkhpZ2gg
bWVtb3J5OiA3ODY0MzJrCjw2Pk1lbW9yeTogMTU1MDU4OGsvMTU3Mjg2NGsgYXZhaWxhYmxlICgz
MjY0ayBrZXJuZWwgY29kZSwgODA3NjQ4ayByZXNlcnZlZCwgMTUyayBkYXRhLCAyNzhrIGJzcywg
MTcyayBpbml0KQo8Nj5TTFVCOiBHZW5zbGFicz05LCBIV2FsaWduPTMyLCBPcmRlcj0wLTEsIE1p
bk9iamVjdHM9NCwgQ1BVcz0xLCBOb2Rlcz0xCjw3PkNhbGlicmF0aW5nIGRlbGF5IGxvb3AuLi4g
NjYuNTYgQm9nb01JUFMgKGxwaj0xMzMxMjApCjw0Pk1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50
cmllczogNTEyCjw0PkNhbGxpbmcgbnVtYV9kZWZhdWx0X3BvbGljeSgpCjw0PkNhbGxpbmcgdW5s
b2NrX2tlcm5lbCgpCjw0PkNhbGxpbmcgaW5pdF9pZGxlX2Jvb3R1cF90YXNrKCkKPDQ+Q2FsbGlu
ZyBwcmVlbXB0X2VuYWJsZV9ub19yZXNjaGVkKCkKPDQ+Q2FsbGluZyBzY2hlZHVsZSgpCjw0PkNh
bGxpbmcgaW5pdGNhbGwgMHhjMDMyMTc4NDogaW5pdF9jcHVmcmVxX3RyYW5zaXRpb25fbm90aWZp
ZXJfbGlzdCsweDAvMHgyYygpCjw0PmluaXRjYWxsIDB4YzAzMjE3ODQ6IGluaXRfY3B1ZnJlcV90
cmFuc2l0aW9uX25vdGlmaWVyX2xpc3QrMHgwLzB4MmMoKSByZXR1cm5lZCAwLgo8ND5pbml0Y2Fs
bCAweGMwMzIxNzg0IHJhbiBmb3IgMCBtc2VjczogaW5pdF9jcHVmcmVxX3RyYW5zaXRpb25fbm90
aWZpZXJfbGlzdCsweDAvMHgyYygpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMyMWEzMDogbmV0
X25zX2luaXQrMHgwLzB4MTg4KCkKPDY+bmV0X25hbWVzcGFjZTogNjQgYnl0ZXMKPDQ+aW5pdGNh
bGwgMHhjMDMyMWEzMDogbmV0X25zX2luaXQrMHgwLzB4MTg4KCkgcmV0dXJuZWQgMC4KPDQ+aW5p
dGNhbGwgMHhjMDMyMWEzMCByYW4gZm9yIDAgbXNlY3M6IG5ldF9uc19pbml0KzB4MC8weDE4OCgp
Cjw0PkNhLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLiAweGMwMzEyZjFjOiBkbWFfYWxsb2NfaW5pdCsweDAvMHhhYygpIHJldHVy
bmVkIDAuCjw0PmluaXRjYWxsIDB4YzAzMTJmMWMgcmFuIGZvciAwIG1zZWNzOiBkbWFfYWxsb2Nf
aW5pdCsweDAvMHhhYygpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxNDFkNDogc3lzY3RsX2lu
aXQrMHgwLzB4NDQoKQo8ND5pbml0Y2FsbCAweGMwMzE0MWQ0OiBzeXNjdGxfaW5pdCsweDAvMHg0
NCgpIHJldHVybmVkIDAuCjw0PmluaXRjYWxsIDB4YzAzMTQxZDQgcmFuIGZvciAwIG1zZWNzOiBz
eXNjdGxfaW5pdCsweDAvMHg0NCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxNTFiMDogaW5p
dF9qaWZmaWVzX2Nsb2Nrc291cmNlKzB4MC8weDI4KCkKPDQ+aW5pdGNhbGwgMHhjMDMxNTFiMC4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi5jMDMxNTFiMCByYW4gZm9yIDAgbXNlY3M6IGluaXRfamlmZmllc19jbG9ja3NvdXJjZSsw
eDAvMHgyOCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxNTcwNDoga3N5c2ZzX2luaXQrMHgw
LzB4OTAoKQo8ND5pbml0Y2FsbCAweGMwMzE1NzA0OiBrc3lzZnNfaW5pdCsweDAvMHg5MCgpIHJl
dHVybmVkIDAuCjw0PmluaXRjYWxsIDB4YzAzMTU3MDQgcmFuIGZvciAwIG1zZWNzOiBrc3lzZnNf
aW5pdCsweDAvMHg5MCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxODNlODogZmlsZWxvY2tf
aW5pdCsweDAvMHg0OCgpCjw0PmluaXRjYWxsIDB4YzAzMTgzZTg6IGZpbGVsb2NrX2luaXQrMHgw
LzB4NDgoKSByZXR1cm5lZCAwLgo8ND5pbml0Y2FsbCAweGMwMzE4M2U4IHJhbiBmb3IgMCBtc2Vj
czogZmlsZWxvY2tfaW5pdCsweDAvMHg0OCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLl9zY3JpcHRfYmluZm10KzB4MC8weDI4KCkgcmV0dXJuZWQgMC4KPDQ+aW5pdGNhbGwgMHhj
MDMxOGZiYyByYW4gZm9yIDAgbXNlY3M6IGluaXRfc2NyaXB0X2JpbmZtdCsweDAvMHgyOCgpCjw0
PkNhbGxpbmcgaW5pdGNhbGwgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLm5pdF9lbGZfYmluZm10KzB4MC8weDI4KCkgcmV0dXJu
ZWQgMC4KPDQ+aW5pdGNhbGwgMHhjMDMxOGZlNCByYW4gZm9yIDAgbXNlY3M6IGluaXRfZWxmX2Jp
bmZtdCsweDAvMHgyOCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxOWM2ODogZGVidWdmc19p
bml0KzB4MC8weDY4KCkKPDQ+aW5pdGNhbGwgMHhjMDMxOWM2ODogZGVidWdmc19pbml0KzB4MC8w
eDY4KCkgcmV0dXJuZWQgMC4KPDQ+aW5pdGNhbGwgMHhjMDMxOWM2OCByYW4gZm9yIDAgbXNlY3M6
IGRlYnVnZnNfaW5pdCsweDAvMHg2OCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMxYTg4NDog
cmFuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uX2luaXQrMHgwLzB4MzAoKQo8ND5pbml0Y2FsbCAweGMw
MzIxNzU0OiBjcHVmcmVxX2NvcmVfaW5pdCsweDAvMHgzMCgpIHJldHVybmVkIDAuCjw0PmluaXRj
YWxsIDB4YzAzMjE3NTQgcmFuIGZvciAwIG1zZWNzOiBjcHVmcmVxX2NvcmVfaW5pdCsweDAvMHgz
MCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMyMTg5MDogc29ja19pbml0KzB4MC8weDg0KCkK
PDQ+aW5pdGNhbGwgMHhjMDMyMTg5MDogc29ja19pbml0KzB4MC8weDg0KCkgcmV0dXJuZWQgMC4K
PDQ+aW5pdGNhbGwgMHhjMDMyMTg5MCByYW4gZm9yIDAgbXNlY3M6IHNvY2tfaW5pdCsweDAvMHg4
NCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMyMjM1MDogbmV0cG9sbF9pbml0KzB4MC8weDIw
KCkKPDQ+aW5pdGNhbGwgMHhjMDMyMjM1MDogbmV0cG9sbF9pbml0KzB4MC8weDIwKCkgcmV0dXJu
ZWQgMC4KPDQ+aW5pdGNhbGwgMHhjMDMyMjM1MCByYW4gZm9yIDAgbXNlY3M6IG5ldHBvbGxfaW5p
dCsweDAvMHgyMCgpCjw0PkNhbGxpbmcgaW5pdGNhbGwgMHhjMDMyMjYyODogbmV0bGlua19wcm90
b19pbml0KzB4MC8weDE1OCgpCjw2Pk5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTYK
PDQ+aW5pdGNhbGwgMHhjMDMyMjYyODogbmV0bGlua19wcm90b19pbml0KzB4MC8weDE1OCgpIHJl
dHVybmVkIDAuCjw0PmluaXRjYWxsIDB4YzAzMjI2MjggcmFuIGZvciAwIG1zZWNzOiBuZXRsaW5r
X3Byb3RvX2luaXQrMHgwLzB4MTU4KCkKPDQ+Q2FsbGluZyBpbml0Y2FsbCAweGMwMzBiZTU0OiBv
Zl9idXNfZHJpdmVyX2luaXQrMHgwLzB4MzAoKQo8ND5pbml0Y2FsbCAweGMwMzBiZTU0OiBvZl9i
dXNfZHJpdmVyX2luaXQrMHgwLzB4MzAoKSByZXR1cm5lZCAwLgo8ND5pbml0Y2FsbCAweGMwMzBi
ZTU0IHJhbiAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLjoga29iamVjdF91ZXZlbnRfaW5pdCsweDAvMHg2OCgpIHJl
dHVybmVkIDAuCjw0PmluaXRjYWxsIDB4YzAzMWE3MjAgcmFuIGZvciAwIG1zZWNzOiBrb2JqZWN0
X3VldmVudF9pbml0KzB4MC8weDY4KCkKPDQ+Q2FsbGluZyBpbml0Y2FsbCAweGMwMzFhOGY0OiBw
Y2lidXNfY2xhc3NfaW5pdCsweDAvMHgyOCgpCjw0PmluaXRjYWxsIDB4YzAzMWE4ZjQ6IHBjaWJ1
c19jbGFzc19pbml0KzB4MC8weDI4KCkgcmV0dXJuZWQgMC4KPDQ+aW5pdGNhbGwgMHhjMDMxYThm
NCByYW4gZm9yIDAgbXNlY3M6IHBjaWJ1c19jbGFzc19pbml0KzB4MC8weDI4KCkKPDQ+Q2FsbGlu
ZyBpbml0Y2FsbCAweGMwMzFhZjU0OiBwY2lfZHJpdmVyX2luaXQrMHgwLzB4MjgoKQo8ND5pbml0
Y2FsbCAweGMwMzFhZjU0OiBwY2lfZHJpdmVyX2luaXQrMHgwLzB4MjgoKSByZXR1cm5lZCAwLgo8
ND5pbml0Y2FsbCAweGMwMzFhZjU0IHJhbiBmb3IgMCBtc2VjczogcGNpX2RyaXZlcl9pbml0KzB4
MC8weDI4KCkKPDQ+Q2FsbGluZyBpLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLjB4YzAzMWI3YzQ6IGJhY2tsaWdodF9jbGFzc19p
bml0KzB4MC8weDc0KCkgcmV0dXJuZWQgMC4KPDQ+aW5pdGMuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4KPDQ+Q2FsbGluZyBpbml0
Y2FsbCAweGMwMzFiZDJjOiB2aWRlb19vdXRwdXRfY2xhc3NfaW5pdCsweDAvMHgyOC4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi50
dXJuZWQgMC4KPDQ+aW5pdGNhbGwgMHhjMDMxYmQyYyByYW4gZm9yIDAgbXNlY3M6IHZpZGVvX291
dHB1dF9jbGFzc19pbml0KzB4MC8weDI4KCkKPDQ+Q2FsbGluZyBpbml0Y2FsbCAweGMwMzFjMGU0
OiB0dHlfY2xhc3NfaS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4gcmV0dXJuZWQgMC4KPDQ+aW5pdGNhbGwgMHhjMDMxYzBlNCBy
YW4gZm9yIDAgbXNlY3M6IHR0eV9jbGFzc19pbml0KzB4MC8weDQ0KCkKPDQ+Q2FsbGluZyBpbml0
Y2FsbCAweGMwMzFjYjBjOiB2dGNvbnNvbGVfY2xhc3NfaW5pdCsweDAvMHhmMCgpCjw0PmluaXRj
YWxsIDB4YzAzMWNiMGM6IHZ0Y29uc29sZV9jbGFzc19pbml0KzB4MC8weGYwKCkgcmV0dXJuZWQg
MC4KPDQ+aW5pdGNhbGwgMHhjMDMxY2IwYyByYW4gZm9yIDAgbXNlY3M6IHZ0Y29uc29sZV9jbGFz
c19pbml0KzB4MC8weGYwKCkKPDQ+Q2FsbGluZyBpbml0Y2FsbCAweGMwMDA2OWE4OiBpcnFfbGF0
ZV9pbml0KzB4MC8weDg4KCkKPDQ+aW5pdGNhbGwgMHhjMDAwNjlhODogaXJxX2xhdGVfaW5pdCsw
eDAvMHguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uZV9pbml0KzB4MC8weDg4KCkKPDQ+Q2FsbGluZyBpbml0Y2FsbCAweGMwMzBi
OWQ4OiB2ZHNvX2luaXQrMHgwLzB4NDNjKCkKPDQ+aW5pdGNhbGwgMHhjMDMwYjlkODogdmRzb19p
bml0KzB4MC8weDQzYygpIHJldHVybmVkIDAuCjw0PmluaXRjYWxsIDB4YzAzMGI5ZDggcmFuIGZv
ciAwIG1zZWNzOiB2ZHNvX2luaXQrMHgwLzB4NDNjKCkKPDQ+Q2FsbGluZyBpbml0Y2FsbCAweGMw
MDBmNzFjOiBwb3dlcnBjX2RlYnVnZnNfaW5pdCsweDAvMHg0MCgpLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gMC4KPDQ+aW5p
dGNhbGwgMHhjMDAwZjcxYyByYW4gZm9yIDAgbXNlY3M6IHBvd2VycGNfZGVidWdmc19pbml0Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi5hbGwgMHhjMDMwZGJjMCByYW4gZm9yIDAgbXNlY3M6IHBwY19pbml0KzB4MC8w
eDg0KCkKPDQ+Q2FsbGluZyBpLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiBoYXJkd2FyZQo8Nz5QQ0k6IFNjYW5uaW5nIGJ1cyAw
MDAwOjAwCjw3PlBDSTogRm91bmQgMDAwMDowMDowMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiBDYWxsaW5nIHF1
aXJrIGMwMDEyZTM0IGZvciAwMDAwOjAwOjAxLjAKPDc+UENJOiBGb3VuZCAwMDAwOjAwOjA2LjAg
WzEwYjcvOTIwMF0gMDAwMjAwIDAwCjw3PlBDSTogQ2FsbGluZyBxdWlyayBjMDAxMmUzNCBmb3Ig
MDAwMDowMDowNi4wCjw3PlBDSTogRm91bmQgMDAwMDowMDowNy4wIFsxMTA2LzA2ODZdIDAwMDYw
MSAwMAo8Nz5QQ0k6IENhbGxpbmcgcXVpcmsgYzAwMTJlMzQgZm9yIDAwMDA6MDA6MDcuMAo8Nz5Q
Q0k6IENhbGxpbmcgcXVpcmsgYzAxMWNkYjggZm9yIDAwMDA6MDA6MDcuMAo8Nz5QQ0k6IEZvdW5k
IDAwMDA6MDA6MDcuMSBbMTEwNi8wNTcxXSAwMDAxMDEgMDAKPDc+UENJOiBDYWxsaW5nIHF1aXJr
IGMwMDEyZTM0IGZvciAwMDAwOjAwOjA3LjEKPDc+UENJOiBGb3VuZCAwMDAwOjAwOjA3LjIgWzEx
MDYvMzAzOF0gMDAwYzAzIDAwCjw3PlBDSTogQ2FsbGluZyBxdWlyayBjMDAxMmUzNCBmb3IgMDAw
MDowMDowNy4yCjw3PlBDSTogRm91bmQgMDAwMDowMDowNy4zIFsxMTA2LzMwMzhdIDAwMGMwMyAw
MAo8Nz5QQ0k6IENhbGxpbmcgcXVpcmsgYzAwMTJlMzQgZm9yIDAwMDA6MDA6MDcuMwo8Nz5QQ0k6
IEZvdW5kIDAwMDA6MDA6MDcuNCBbMTEwNi8zMDU3XSAwMDAwMDAgMDAKPDc+UENJOiBDYWxsaW5n
IHF1aXJrIGMwMDEyZTM0IGZvciAwMDAwOjAwOjA3LjQKPDc+UENJOiBDYWxsaW5nIHF1aXJrIGMw
MTFlNGE0IGZvciAwMDAwOjAwOjA3LjQKPDc+UENJOiBDYWxsaW5nIHF1aXJrIGMwMTFkNzIwIGZv
ciAwMDAwOjAwOjA3LjQKPDc+UENJOiBGb3VuZCAwMDAwOjAwOjA3LjUgWzExMDYvMzA1OF0gMDAw
NDAxIDAwCjw3PlBDSTogQ2FsbGluZyBxdWlyayBjMDAxMmUzNCBmb3IgMDAwMDowMDowNy41Cjw3
PlBDSTogRm91bmQgMDAwMDowMDowNy42IFsxMTA2Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgo8Nz5QQ0k6IEZvdW5kIDAwMDA6
MDA6MDguMCBbMTA5ZS8wMzZlXSAwMDA0MDAgMDAKPDc+UENJOiBDYWxsaW5nIHF1aXJrIGMwMDEy
ZTM0IGZvciAwMDAwOjAwOjA4LjAKPDc+UENJOiBGb3VuZCAwMDAwOjAwOjA4LjEgWzEwOWUvMDg3
OF0gMDAwNDgwIDAwCjw3PlBDSTogQ2FsbGluZyBxdWlyayBjMDAxMmUzNCBmb3IgMDAwMDowMDow
OC4xCjw3PlBDSTogRm91bmQgMDAwMDowMDowOS4wIFsxMTAyLzAwMDJdIDAwMDQwMSAwMAo8Nz5Q
Q0k6IENhbGwuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uMTEwMi83MDAyXSAwMDA5ODAgMDAKPDc+UENJOiBDYWxsaW5nIHF1aXJr
IGMwMDEyZTM0IGZvciAwMDAwOjAwOjA5LjEKPDc+UENJOiBGb3VuZCAwMDAwOjAwOjBhLjAgWzEw
YjkvNTIzN10gMDAwYzAzIDAwCjw3PlBDSTogQ2EuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFsxMGI5LzUyMzddIDAwMGMwMyAw
MAo8Nz5QQ0k6IENhbGxpbmcgcXVpcmsgYzAwMTJlMzQgZm9yIDAwMDA6MC4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi5DYWxsaW5n
IHF1aXJrIGMwMDEyZTM0IGZvciAwMDAwOjAwOjBhLjIKPDc+UENJOiBGb3VuZCAwMDAwOjAwOjBh
LjMgWzEwYjkvNTIzOV0gMDAwYzAzIDAwCjw3PlBDSTogQ2FsbGluZyBxdWlyayBjMDAxMmUzNCBm
b3IgMDAwMDowMDowYS4zCjw3PlBDSTogRm91bmQgMDAwMDowMDowYS40IFsxMGI5LzUyNTNdIDAw
MGMwMCAwMAo8Nz5QQ0k6IENhbGxpbmcgcXVpcmsgYzAwMTJlMzQgZm9yIDAwMDA6MDA6MGEuNAo8
Nz5QQ0k6IEZpeHVwcyBmb3IgYnVzIDAwMDA6MDAKPDc+UENJOiBTY2FubmluZyBiZWhpbmQgUENJ
IGJyaWRnZSAwMDAwOjAwOjAxLjAsIGNvbmZpZyAwMTAxMDAsIHBhc3MgMAo8Nz5QQ0k6IFNjYW5u
aW5nIGJ1cyAwMDAwOjAxCjw3PlBDSTogRm91bmQgMDAwMDowMTowMC4wIFsxMDAyLzU5NjFdIDAw
MDMwMCAwMAo8Nz5QQ0k6IENhbGxpbmcgcXVpcmsgYzAwMTJlMzQgZm9yLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLjc+UENJOiBD
YWxsaW5nIHF1aXJrIGMwMDEyZTM0IGZvciAwMDAwOjAxOjAwLjEKPDc+UENJOiBGaXh1cHMgZm9y
IGJ1cyAwMDAwOjAxCjw3PlBDSTogQnVzIHNjYW4gZm9yIDAwMDA6MDEgcmV0dXJuaW5nIHdpdGgg
bWF4PTAxCjw3PlBDSTogU2Nhbm5pbmcgYmVoaW5kIFBDSSBicmlkZ2UgMDAwMDowMDowMS4wLCBj
b25maWcgMDEwMTAwLCBwYXNzIDEKPDc+UENJOiBCdXMgc2NhbiBmb3IgMDAwMDowMCByZXR1cm5p
bmcgd2l0aCBtYXg9MDEKPDM+UENJOiBDYW5ub3QgYWxsb2NhdGUgcmVzb3VyY2UgcmVnaW9uIDAg
b2YgZGV2aWNlIDAwMDA6MDA6MDAuMAo8Mz5QLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLlBDSTogQ2Fubm90IGFsbG9jYXRlIHJl
c291cmNlIHJlZ2lvbiAxIG9mIGRldmljZSAwMDAwOjAxOjAwLjEKPDM+UENJOiBGYWlsZWQgdG8g
YWxsb2NhdGUgbWVtIHJlc291cmNlICMwOjgwMDAwMDBAODgwMDAwMDAgZm9yIDAwMDA6MDE6MDAu
MQo8Nz4gIGdvdCByZXMgWzg4MDEwMDAwOjg4MDFmZmZmXSBidXMgWzg4MDEwMDAwOjg4MDFmZmZm
XSBmbGFncyAyMDAgZm9yIEJBUiAxIG9mIDAwMDA6MDE6MDAuMQo8Nz5QQ0k6IG1vdmVkIGRldmlj
ZSAwMDAwOjAxOjAwLjEgcmVzb3VyY2UgMSAoMjAwKSB0byA4ODAxMDAwMAo8ND5pbml0Y2FsbCAw
eGMwMzExYTA0OiBwY2liaW9zX2luaXQrMHgwLzB4MWU4KCkgcmV0dXJuZWQgMC4KPDQ+aW5pdGNh
bGwgMHhjMDMxMWEwNCByYW4gZm9yIDMgbXNlY3M6IHBjaWJpb3NfaW5pdCsweDAvMHgxZTgoKQo8
ND5DYWxsaW5nIGluaXRjYWxsIDB4YzAzMTQ5Yjg6IHBhcmFtX3N5c2ZzX2luaXQrMHgwLzB4MWE4
KCkKPDQ+aW5pdGNhbGwgMHhjMDMxNDliODogcGFyYW1fLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLiBtc2VjczogcmVhZGFoZWFkX2luaXQrMHgwLzB4MjgoKQo8ND5DYWxsaW5nIGluaXRjYWxs
IDB4YzAzMThiNjQ6IGluaXRfYmlvKzB4MC8weGYwKCkKPDQ+aW5pdGNhbGwgMHhjMDMxOGI2NDog
aW5pdF9iaW8rMHgwLzB4ZjAoLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLngwLzB4ZjAoKQo8ND5DYWxsaW5nIGluaXRjYWxsIDB4
YzAzMWEzY2M6IGdlbmhkX2RldmljZV9pbml0KzB4MC8uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4ucm5lZCAwLgo8ND5pbml0Y2Fs
bCAweGMwMzFhM2NjIHJhbiBmb3IgMCBtc2VjczogZ2VuaGRfZGV2aWNlX2luaS4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgo=
--========GMX220631202253421230786
Content-Type: text/x-log; charset="iso-8859-15"; name="kernel-nohighmem.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="kernel-nohighmem.log"

<6>Using AmigaOne machine description
<4>Total memory = 768MB; using 2048kB for hash table (at cfe00000)
<5>Linux version 2.6.24 (geri@earth) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #9 Tue Feb 5 21:42:30 CET 2008
<7>Found legacy serial port 0 for /pci@80000000/isa@7/serial@2f8
<7>  port=2f8, taddr=fe0002f8, irq=0, clk=1843200, speed=0
<7>Found legacy serial port 1 for /pci@80000000/isa@7/serial@3f8
<7>  port=3f8, taddr=fe0003f8, irq=0, clk=1843200, speed=0
<6>console [udbg0] enabled
<7>Entering add_active_range(0, 0, 196608) 0 entries of 256 used
<4>AmigaOne l2cr : L2 cache was not active, activating.
<7>Top of RAM: 0x30000000, Total RAM: 0x30000000
<7>Memory hole size: 0MB
<4>Zone PFN ranges:
<4>  DMA             0 ->   196608
<4>  Normal     196608 ->   196608
<4>Movable zone start PFN for each node
<4>early_node_map[1] active PFN ranges
<4>    0:        0 ->   196608
<7>On node 0 totalpages: 196608
<7>  DMA zone: 1536 pages used for memmap
<7>  DMA zone: 0 pages reserved
<7>  DMA zone: 195072 pages, LIFO batch:31
<7>  Normal zone: 0 pages used for memmap
<7>  Movable zone: 0 pages used for memmap
<4>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195072
<5>Kernel command line: initcall_debug driver_debug debug root=/dev/hda11 console=ttyS0,115200n8r console=tty0 ide0=ata66 ide1=ata66
<6>ide_setup: ide0=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
<6>ide_setup: ide1=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
<6>i8259 legacy interrupt controller initialized
<4>PID hash table entries: 4096 (order: 12, 16384 bytes)
<7>time_init: decrementer frequency = 33.333333 MHz
<7>time_init: processor frequency   = 800.000000 MHz
<6>clocksource: timebase mult[7800001] shift[22] registered
<7>clockevent: decrementer mult[888] shift[16] cpu[0]
<4>Console: colour dummy device 80x25
<6>console handover: boot [udbg0] -> real [tty0]
<6>Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<6>Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>Memory: 772864k/786432k available (3396k kernel code, 13116k reserved, 148k data, 256k bss, ................................................................s=4, CPUs=1, Nodes=1
<7>Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
<4>Mount-cache hash table entries: 512
<4>Calling ................................................................_idle_bootup_task()
<4>Calling preempt_enable_no_resched()
<4>Calling schedule()................................................................................................................................................................................................................................................................................................................................................................................................................................................_init+0x0/0x44()
<4>initcall 0xc03352b0: sysctl_init+0x0/0x44() ................................................................0x0/0x44()
<4>Calling initcall 0xc0336338: init_jiffies_clocksource+0x0/0x28()
<4>initcall 0xc0336338: init_jiffies_clocksource+0x0/0x28() returned 0.
<4>initcall 0xc0336338 ran for 0 msecs: i................................................................................................................................................................................................................................................................................................................................................................................................0x0/0x48()
<4>Calling initcall 0xc033a34c: init_script_binfmt+0x................................................................................................................................................................................................................................................................eturned 0.
<4>initcall 0xc033a374 ran for 0 msecs: init_elf_binf................................................................x80()
<4>initcall 0xc033b078: de................................................................................................................................................................................................................................all 0xc033bd34 ran for 0 msecs: random32_init+0x0/0x34()
<4>Call................................................................................................................................................................................................5c: netpoll_init+0x0/0x20()
<4>initcall 0xc0343e5c: netpoll_init+0x0/0x20() returned 0.
<4>initcall 0xc0343e5c ran for 0 msecs: netpoll_init+0x0/0x20()
<4>Calling initcall 0xc0344134: netlink_................................................................................................................................................................................................x1a8()
<4>Calling initcall 0xc032c528: of_bus_driver_init+0x0/0x................................................................................................................................t+0x0/0x30()
<4>Calling initcall 0xc033bbc0: kobject_uevent_init................................................................................................................................................................................................ss_init+0x0/0x28()
<4>initcall 0xc033bda4: pcibus_class_init+0x0................................................................................................................................................................0xc033c48c: pci_driver_init+0x0/................................................................

--========GMX220631202253421230786
Content-Type: text/x-log;
 charset="iso-8859-15";
 name="kernel-debugpagealloc.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="kernel-debugpagealloc.log"

<6>Using AmigaOne machine description
<4>Total memory = 768MB; using 2048kB for hash table (at cfe00000)
<7>RAM mapped without BATs
<5>Linux version 2.6.24 (geri@earth) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #10 Tue Feb 5 22:08:04 CET 2008
<7>Found legacy serial port 0 for /pci@80000000/isa@7/serial@2f8
<7>  port=2f8, taddr=fe0002f8, irq=0, clk=1843200, speed=0
<7>Found legacy serial port 1 for /pci@80000000/isa@7/serial@3f8
<7>  port=3f8, taddr=fe0003f8, irq=0, clk=1843200, speed=0
<6>console [udbg0] enabled
<7>Entering add_active_range(0, 0, 196608) 0 entries of 256 used
<4>AmigaOne l2cr : L2 cache was not active, activating.
<7>Top of RAM: 0x30000000, ................................hole size: 0MB
<4>Zone PFN ranges:
<4>  DMA             0 ->   196608
<4>  Normal     196608 ->   196608
<4>Movable zone start PFN for each node
<4>early_node_map[1] active PFN ranges
<4>    0:        0 ->   196608
<7>On node 0 totalpages: 196608..........................................................................................................................................

--========GMX220631202253421230786
Content-Type: text/x-log;
 charset="iso-8859-15";
 name="kernel-pages_at_lower_pfns.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="kernel-pages_at_lower_pfns.log"

<4>Crash kernel location must be 0x2000000
<6>Reserving 0MB of memory at 32MB for crashkernel (System RAM: 1536MB)
<6>Using AmigaOne machine description
<4>Total memory = 1536MB; using 4096kB for hash table (at cfc00000)
<5>Linux version 2.6.24 (geri@earth) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #42 Tue Feb 5 22:43:29 CET 2008
<7>Found legacy serial port 0 for /pci@80000000/isa@7/serial@2f8
<7>  port=2f8, taddr=fe0002f8, irq=0, clk=1843200, speed=0
<7>Found legacy serial port 1 for /pci@80000000/isa@7/serial@3f8
<7>  port=3f8, taddr=fe0003f8, irq=0, clk=1843200, speed=0
<6>console [udbg0] enabled
<7>Entering add_active_range(0, 0, 393216) 0 entries of 256 used
<4>AmigaOne l2cr : L2 cache was not active, activating.
<7>Top of RAM: 0x60000000, Total RAM: 0x60000000
<7>Memory hole size: 0MB
<4>Zone PFN ranges:
<4>  DMA             0 ->   196608
<4>  Normal     196608 ->   196608
<4>  HighMem    196608 ->   393216
<4>Movable zone start PFN for each node
<4>early_node_map[1] active PFN ranges
<4>    0:        0 ->   393216
<7>On node 0 totalpages: 393216
<7>  DMA zone: 1536 pages used for memmap
<7>  DMA zone: 0 pages reserved
<7>  DMA zone: 195072 pages, LIFO batch:31
<7>  Normal zone: 0 pages used for memmap
<7>  HighMem zone: 1536 pages used for memmap
<7>  HighMem zone: 195072 pages, LIFO batch:31
<7>  Movable zone: 0 pages used for memmap
<4>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390144
<5>Kernel command line: initcall_debug driver_debug debug root=/dev/hda11 console=ttyS0,115200n8r console=tty0 ide0=ata66 ide1=ata66
<6>ide_setup: ide0=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
<6>ide_setup: ide1=ata66 -- OBSOLETE OPTION, WILL BE REMOVED SOON!
<6>i8259 legacy interrupt controller initialized
<4>PID hash table entries: 4096 (order: 12, 16384 bytes)
<7>time_init: decrementer frequency = 33.333333 MHz
<7>time_init: processor frequency   = 800.000000 MHz
<6>clocksource: timebase mult[7800001] shift[22] registered
<7>clockevent: decrementer mult[888] shift[16] cpu[0]
<4>Console: colour dummy device 80x25
<6>console handover: boot [udbg0] -> real [tty0]
<6>Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<6>Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<7>High memory: 786432k
<6>Memory: 1550204k/1572864k available (3552k kernel code, 807952k reserved, 152k data, 291k bss, 176k init)
<6>SLUB: Genslabs=9, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
<7>Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
<6>Security Framework initialized
<6>SELinux:  Disabled at boot.
<6>Capability LSM initialized
<4>Mount-cache hash table entries: 512
<4>Calling numa_default_policy()
<4>Calling unlock_kernel()
<4>Calling init_idle_bootup_task()
<4>Calling preempt_enable_no_resched()
<4>Calling schedule()
<4>Calling initcall 0xc0369608: init_cpufreq_transition_notifier_list+0x0/0x2c()
<4>initcall 0xc0369608: init_cpufreq_transition_notifier_list+0x0/0x2c() returned 0.
<4>initcall 0xc0369608 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x2c()
<4>Calling initcall 0xc0369924: net_ns_init+0x0/0x188()
<6>net_namespace: 64 bytes
<4>initcall 0xc0369924: net_ns_init+0x0/0x188() returned 0.
<4>initcall 0xc0369924 ran for 0 msecs: net_ns_init+0x0/0x188()
<4>Calling initcall 0xc0359e68: dma_alloc_init+0x0/0xac()
<4>initcall 0xc0359e68: dma_alloc_init+0x0/0xac() returned 0.
<4>initcall 0xc0359e68 ran for 0 msecs: dma_alloc_init+0x0/0xac()
<4>Calling initcall 0xc035b120: sysctl_init+0x0/0x44()
<4>initcall 0xc035b120: sysctl_init+0x0/0x44() returned 0.
<4>initcall 0xc035b120 ran for 0 msecs: sysctl_init+0x0/0x44()
<4>Calling initcall 0xc035c0fc: init_jiffies_clocksource+0x0/0x28()
<4>initcall 0xc035c0fc: init_jiffies_clocksource+0x0/0x28() returned 0.
<4>initcall 0xc035c0fc ran for 0 msecs: init_jiffies_clocksource+0x0/0x28()
<4>Calling initcall 0xc035ccfc: ksysfs_init+0x0/0x90()
<4>initcall 0xc035ccfc: ksysfs_init+0x0/0x90() returned 0.
<4>initcall 0xc035ccfc ran for 0 msecs: ksysfs_init+0x0/0x90()
<4>Calling initcall 0xc035f8a4: filelock_init+0x0/0x48()
<4>initcall 0xc035f8a4: filelock_init+0x0/0x48() returned 0.
<4>initcall 0xc035f8a4 ran for 0 msecs: filelock_init+0x0/0x48()
<4>Calling initcall 0xc0360478: init_script_binfmt+0x0/0x28()
<4>initcall 0xc0360478: init_script_binfmt+0x0/0x28() returned 0.
<4>initcall 0xc0360478 ran for 0 msecs: init_script_binfmt+0x0/0x28()
<4>Calling initcall 0xc03604a0: init_elf_binfmt+0x0/0x28()
<4>initcall 0xc03604a0: init_elf_binfmt+0x0/0x28() returned 0.
<4>initcall 0xc03604a0 ran for 0 msecs: init_elf_binfmt+0x0/0x28()
<4>Calling initcall 0xc0361124: debugfs_init+0x0/0x68()
<4>initcall 0xc0361124: debugfs_init+0x0/0x68() returned 0.
<4>initcall 0xc0361124 ran for 0 msecs: debugfs_init+0x0/0x68()
<4>Calling initcall 0xc03616a8: securityfs_init+0x0/0x68()
<4>initcall 0xc03616a8: securityfs_init+0x0/0x68() returned 0.
<4>initcall 0xc03616a8 ran for 0 msecs: securityfs_init+0x0/0x68()
<4>Calling initcall 0xc03623ec: random32_init+0x0/0x34()
<4>initcall 0xc03623ec: random32_init+0x0/0x34() returned 0.
<4>initcall 0xc03623ec ran for 0 msecs: random32_init+0x0/0x34()
<4>Calling initcall 0xc03695d8: cpufreq_core_init+0x0/0x30()
<4>initcall 0xc03695d8: cpufreq_core_init+0x0/0x30() returned 0.
<4>initcall 0xc03695d8 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
<4>Calling initcall 0xc0369784: sock_init+0x0/0x84()
<4>initcall 0xc0369784: sock_init+0x0/0x84() returned 0.
<4>initcall 0xc0369784 ran for 0 msecs: sock_init+0x0/0x84()
<4>Calling initcall 0xc036a244: netpoll_init+0x0/0x20()
<4>initcall 0xc036a244: netpoll_init+0x0/0x20() returned 0.
<4>initcall 0xc036a244 ran for 0 msecs: netpoll_init+0x0/0x20()
<4>Calling initcall 0xc036a51c: netlink_proto_init+0x0/0x158()
<6>NET: Registered protocol family 16
<4>initcall 0xc036a51c: netlink_proto_init+0x0/0x158() returned 0.
<4>initcall 0xc036a51c ran for 3 msecs: netlink_proto_init+0x0/0x158()
<4>Calling initcall 0xc0352eb8: of_bus_driver_init+0x0/0x30()
<4>initcall 0xc0352eb8: of_bus_driver_init+0x0/0x30() returned 0.
<4>initcall 0xc0352eb8 ran for 0 msecs: of_bus_driver_init+0x0/0x30()
<4>Calling initcall 0xc0362288: kobject_uevent_init+0x0/0x68()
<4>initcall 0xc0362288: kobject_uevent_init+0x0/0x68() returned 0.
<4>initcall 0xc0362288 ran for 0 msecs: kobject_uevent_init+0x0/0x68()
<4>Calling initcall 0xc036245c: pcibus_class_init+0x0/0x28()
<4>initcall 0xc036245c: pcibus_class_init+0x0/0x28() returned 0.
<4>initcall 0xc036245c ran for 0 msecs: pcibus_class_init+0x0/0x28()
<4>Calling initcall 0xc0362abc: pci_driver_init+0x0/0x28()
<4>initcall 0xc0362abc: pci_driver_init+0x0/0x28() returned 0.
<4>initcall 0xc0362abc ran for 0 msecs: pci_driver_init+0x0/0x28()
<4>Calling initcall 0xc03633c4: backlight_class_init+0x0/0x74()
<4>initcall 0xc03633c4: backlight_class_init+0x0/0x74() returned 0.
<4>initcall 0xc03633c4 ran for 0 msecs: backlight_class_init+0x0/0x74()
<4>Calling initcall 0xc036392c: video_output_class_init+0x0/0x28()
<4>initcall 0xc036392c: video_output_class_init+0x0/0x28() returned 0.
<4>initcall 0xc036392c ran for 0 msecs: video_output_class_init+0x0/0x28()
<4>Calling initcall 0xc0363ce4: tty_class_init+0x0/0x44()
<4>initcall 0xc0363ce4: tty_class_init+0x0/0x44() returned 0.
<4>initcall 0xc0363ce4 ran for 0 msecs: tty_class_init+0x0/0x44()
<4>Calling initcall 0xc036470c: vtconsole_class_init+0x0/0xf0()
<4>initcall 0xc036470c: vtconsole_class_init+0x0/0xf0() returned 0.
<4>initcall 0xc036470c ran for 0 msecs: vtconsole_class_init+0x0/0xf0()
<4>Calling initcall 0xc0006948: irq_late_init+0x0/0x88()
<4>initcall 0xc0006948: irq_late_init+0x0/0x88() returned 0.
<4>initcall 0xc0006948 ran for 0 msecs: irq_late_init+0x0/0x88()
<4>Calling initcall 0xc0352a3c: vdso_init+0x0/0x43c()
<4>initcall 0xc0352a3c: vdso_init+0x0/0x43c() returned 0.
<4>initcall 0xc0352a3c ran for 0 msecs: vdso_init+0x0/0x43c()
<4>Calling initcall 0xc000f70c: powerpc_debugfs_init+0x0/0x40()
<4>initcall 0xc000f70c: powerpc_debugfs_init+0x0/0x40() returned 0.
<4>initcall 0xc000f70c ran for 0 msecs: powerpc_debugfs_init+0x0/0x40()
<4>Calling initcall 0xc0354c80: ppc_init+0x0/0x84()
<4>initcall 0xc0354c80: ppc_init+0x0/0x84() returned 0.
<4>initcall 0xc0354c80 ran for 0 msecs: ppc_init+0x0/0x84()
<4>Calling initcall 0xc03587d0: pcibios_init+0x0/0x1e8()
<6>PCI: Probing PCI hardware
<3>PCI: Cannot allocate resource region 0 of device 0000:00:00.0
<3>PCI: Cannot allocate resource region 0 of device 0000:01:00.1
<3>PCI: Cannot allocate resource region 1 of device 0000:01:00.1
<3>PCI: Failed to allocate mem resource #0:8000000@88000000 for 0000:01:00.1
<4>initcall 0xc03587d0: pcibios_init+0x0/0x1e8() returned 0.
<4>initcall 0xc03587d0 ran for 3 msecs: pcibios_init+0x0/0x1e8()
<4>Calling initcall 0xc035b904: param_sysfs_init+0x0/0x1a8()
<4>initcall 0xc035b904: param_sysfs_init+0x0/0x1a8() returned 0.
<4>initcall 0xc035b904 ran for 3 msecs: param_sysfs_init+0x0/0x1a8()
<4>Calling initcall 0xc035efb8: readahead_init+0x0/0x28()
<4>initcall 0xc035efb8: readahead_init+0x0/0x28() returned 0.
<4>initcall 0xc035efb8 ran for 0 msecs: readahead_init+0x0/0x28()
<4>Calling initcall 0xc0360020: init_bio+0x0/0xf0()
<4>initcall 0xc0360020: init_bio+0x0/0xf0() returned 0.
<4>initcall 0xc0360020 ran for 0 msecs: init_bio+0x0/0xf0()
<4>Calling initcall 0xc0361f34: genhd_device_init+0x0/0x74()
<4>initcall 0xc0361f34: genhd_device_init+0x0/0x74() returned 0.
<4>initcall 0xc0361f34 ran for 0 msecs: genhd_device_init+0x0/0x74()
<4>Calling initcall 0xc0362ec4: fbmem_init+0x0/0xc8()
<4>initcall 0xc0362ec4: fbmem_init+0x0/0xc8() returned 0.
<4>initcall 0xc0362ec4 ran for 0 msecs: fbmem_init+0x0/0xc8()
<4>Calling initcall 0xc03640e4: misc_init+0x0/0xb8()
<4>initcall 0xc03640e4: misc_init+0x0/0xb8() returned 0.
<4>initcall 0xc03640e4 ran for 0 msecs: misc_init+0x0/0xb8()
<4>Calling initcall 0xc036813c: init_scsi+0x0/0xa8()
<5>SCSI subsystem initialized
<4>initcall 0xc036813c: init_scsi+0x0/0xa8() returned 0.
<4>initcall 0xc036813c ran for 0 msecs: init_scsi+0x0/0xa8()
<4>Calling initcall 0xc036848c: ata_init+0x0/0xbc()
<7>libata version 3.00 loaded.
<4>initcall 0xc036848c: ata_init+0x0/0xbc() returned 0.
<4>initcall 0xc036848c ran for 0 msecs: ata_init+0x0/0xbc()
<4>Calling initcall 0xc0368820: serio_init+0x0/0xa4()
<4>initcall 0xc0368820: serio_init+0x0/0xa4() returned 0.
<4>initcall 0xc0368820 ran for 0 msecs: serio_init+0x0/0xa4()
<4>Calling initcall 0xc03689ec: input_init+0x0/0x13c()
<4>initcall 0xc03689ec: input_init+0x0/0x13c() returned 0.
<4>initcall 0xc03689ec ran for 0 msecs: input_init+0x0/0x13c()
<4>Calling initcall 0xc0368de4: rtc_init+0x0/0x88()
<4>initcall 0xc0368de4: rtc_init+0x0/0x88() returned 0.
<4>initcall 0xc0368de4 ran for 0 msecs: rtc_init+0x0/0x88()
<4>Calling initcall 0xc03693b0: i2c_init+0x0/0x44()
<4>initcall 0xc03693b0: i2c_init+0x0/0x44() returned 0.
<4>initcall 0xc03693b0 ran for 0 msecs: i2c_init+0x0/0x44()
<4>Calling initcall 0xc03694b0: hwmon_init+0x0/0x64()
<4>initcall 0xc03694b0: hwmon_init+0x0/0x64() returned 0.
<4>initcall 0xc03694b0 ran for 0 msecs: hwmon_init+0x0/0x64()
<4>Calling initcall 0xc0369864: proto_init+0x0/0x54()
<4>initcall 0xc0369864: proto_init+0x0/0x54() returned 0.
<4>initcall 0xc0369864 ran for 0 msecs: proto_init+0x0/0x54()
<4>Calling initcall 0xc0369d1c: net_dev_init+0x0/0x12c()
<4>initcall 0xc0369d1c: net_dev_init+0x0/0x12c() returned 0.
<4>initcall 0xc0369d1c ran for 0 msecs: net_dev_init+0x0/0x12c()
<4>Calling initcall 0xc0369ee4: neigh_init+0x0/0x98()
<4>initcall 0xc0369ee4: neigh_init+0x0/0x98() returned 0.
<4>initcall 0xc0369ee4 ran for 0 msecs: neigh_init+0x0/0x98()
<4>Calling initcall 0xc036a264: fib_rules_init+0x0/0x70()
<4>initcall 0xc036a264: fib_rules_init+0x0/0x70() returned 0.
<4>initcall 0xc036a264 ran for 0 msecs: fib_rules_init+0x0/0x70()
<4>Calling initcall 0xc036a2d4: pktsched_init+0x0/0xf4()
<4>initcall 0xc036a2d4: pktsched_init+0x0/0xf4() returned 0.
<4>initcall 0xc036a2d4 ran for 0 msecs: pktsched_init+0x0/0xf4()
<4>Calling initcall 0xc036a3f0: tc_filter_init+0x0/0x70()
<4>initcall 0xc036a3f0: tc_filter_init+0x0/0x70() returned 0.
<4>initcall 0xc036a3f0 ran for 0 msecs: tc_filter_init+0x0/0x70()
<4>Calling initcall 0xc036a460: tc_action_init+0x0/0x70()
<4>initcall 0xc036a460: tc_action_init+0x0/0x70() returned 0.
<4>initcall 0xc036a460 ran for 0 msecs: tc_action_init+0x0/0x70()
<4>Calling initcall 0xc036a674: genl_init+0x0/0xf8()
<4>Calling preempt_disable()
<4>Calling cpu_idle()
<4>Calling cpu_idle()
<4>initcall 0xc036a674: genl_init+0x0/0xf8() returned 0.
<4>initcall 0xc036a674 ran for 7 msecs: genl_init+0x0/0xf8()
<4>Calling initcall 0xc036bf74: atm_init+0x0/0xd4()
<6>NET: Registered protocol family 8
<6>NET: Registered protocol family 20
<4>initcall 0xc036bf74: atm_init+0x0/0xd4() returned 0.
<4>initcall 0xc036bf74 ran for 0 msecs: atm_init+0x0/0xd4()
<4>Calling initcall 0xc036c1e4: wireless_nlevent_init+0x0/0x20()
<4>initcall 0xc036c1e4: wireless_nlevent_init+0x0/0x20() returned 0.
<4>initcall 0xc036c1e4 ran for 0 msecs: wireless_nlevent_init+0x0/0x20()
<4>Calling initcall 0xc0359f14: add_rtc+0x0/0xcc()
<4>initcall 0xc0359f14: add_rtc+0x0/0xcc() returned 0.
<4>initcall 0xc0359f14 ran for 0 msecs: add_rtc+0x0/0xcc()
<4>Calling initcall 0xc035bfb0: clocksource_done_booting+0x0/0x14()
<4>initcall 0xc035bfb0: clocksource_done_booting+0x0/0x14() returned 0.
<4>initcall 0xc035bfb0 ran for 0 msecs: clocksource_done_booting+0x0/0x14()
<4>Calling initcall 0xc035f7f0: init_pipe_fs+0x0/0x70()
<4>initcall 0xc035f7f0: init_pipe_fs+0x0/0x70() returned 0.
<4>initcall 0xc035f7f0 ran for 0 msecs: init_pipe_fs+0x0/0x70()
<4>Calling initcall 0xc03602b8: eventpoll_init+0x0/0x98()
<4>initcall 0xc03602b8: eventpoll_init+0x0/0x98() returned 0.
<4>initcall 0xc03602b8 ran for 0 msecs: eventpoll_init+0x0/0x98()
<4>Calling initcall 0xc0360350: anon_inode_init+0x0/0x128()
<4>initcall 0xc0360350: anon_inode_init+0x0/0x128() returned 0.
<4>initcall 0xc0360350 ran for 0 msecs: anon_inode_init+0x0/0x128()
<4>Calling initcall 0xc0363954: chr_dev_init+0x0/0xbc()
<4>initcall 0xc0363954: chr_dev_init+0x0/0xbc() returned 0.
<4>initcall 0xc0363954 ran for 0 msecs: chr_dev_init+0x0/0xbc()
<4>Calling initcall 0xc0367434: loopback_init+0x0/0x28()
<4>initcall 0xc0367434: loopback_init+0x0/0x28() returned 0.
<4>initcall 0xc0367434 ran for 0 msecs: loopback_init+0x0/0x28()
<4>Calling initcall 0xc03696a4: cpufreq_gov_performance_init+0x0/0x28()
<4>initcall 0xc03696a4: cpufreq_gov_performance_init+0x0/0x28() returned 0.
<4>initcall 0xc03696a4 ran for 0 msecs: cpufreq_gov_performance_init+0x0/0x28()
<4>Calling initcall 0xc036b414: inet_init+0x0/0x36c()
<6>NET: Registered protocol family 2
<6>Time: timebase clocksource has been installed.
<7>Switched to high resolution mode on CPU 0
<6>IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
<6>TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<6>TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
<6>TCP: Hash tables configured (established 131072 bind 65536)
<6>TCP reno registered
<4>initcall 0xc036b414: inet_init+0x0/0x36c() returned 0.
<4>initcall 0xc036b414 ran for 49 msecs: inet_init+0x0/0x36c()
<4>Calling initcall 0xc0352568: populate_rootfs+0x0/0xf8()
<4>initcall 0xc0352568: populate_rootfs+0x0/0xf8() returned 0.
<4>initcall 0xc0352568 ran for 0 msecs: populate_rootfs+0x0/0xf8()
<4>Calling initcall 0xc0352e8c: register_powersave_nap_sysctl+0x0/0x2c()
<4>initcall 0xc0352e8c: register_powersave_nap_sysctl+0x0/0x2c() returned 0.
<4>initcall 0xc0352e8c ran for 0 msecs: register_powersave_nap_sysctl+0x0/0x2c()
<4>Calling initcall 0xc0352f08: TAU_init+0x0/0xf4()
<4>Thermal assist unit not available
<4>initcall 0xc0352f08: TAU_init+0x0/0xf4() returned 1.
<4>initcall 0xc0352f08 ran for 0 msecs: TAU_init+0x0/0xf4()
<4>initcall at 0xc0352f08: TAU_init+0x0/0xf4(): returned with error code 1
<4>Calling initcall 0xc03549a0: add_pcspkr+0x0/0x80()
<4>initcall 0xc03549a0: add_pcspkr+0x0/0x80() returned 0.
<4>initcall 0xc03549a0 ran for 0 msecs: add_pcspkr+0x0/0x80()
<4>Calling initcall 0xc03571f8: serial_dev_init+0x0/0x134()
<4>initcall 0xc03571f8: serial_dev_init+0x0/0x134() returned 0.
<4>initcall 0xc03571f8 ran for 0 msecs: serial_dev_init+0x0/0x134()
<4>Calling initcall 0xc0358b3c: audit_classes_init+0x0/0x70()
<4>initcall 0xc0358b3c: audit_classes_init+0x0/0x70() returned 0.
<4>initcall 0xc0358b3c ran for 0 msecs: audit_classes_init+0x0/0x70()
<4>Calling initcall 0xc03595dc: setup_kcore+0x0/0xe0()
<7>setup_kcore: restrict size=3fffffff
<4>initcall 0xc03595dc: setup_kcore+0x0/0xe0() returned 0.
<4>initcall 0xc03595dc ran for 0 msecs: setup_kcore+0x0/0xe0()
<4>Calling initcall 0xc035abec: create_proc_profile+0x0/0x74()
<4>initcall 0xc035abec: create_proc_profile+0x0/0x74() returned 0.
<4>initcall 0xc035abec ran for 0 msecs: create_proc_profile+0x0/0x74()
<4>Calling initcall 0xc035b0b0: ioresources_init+0x0/0x70()
<4>initcall 0xc035b0b0: ioresources_init+0x0/0x70() returned 0.
<4>initcall 0xc035b0b0 ran for 0 msecs: ioresources_init+0x0/0x70()
<4>Calling initcall 0xc035b318: uid_cache_init+0x0/0x94()
<4>initcall 0xc035b318: uid_cache_init+0x0/0x94() returned 0.
<4>initcall 0xc035b318 ran for 0 msecs: uid_cache_init+0x0/0x94()
<4>Calling initcall 0xc035baac: init_posix_timers+0x0/0xc0()
<4>initcall 0xc035baac: init_posix_timers+0x0/0xc0() returned 0.
<4>initcall 0xc035baac ran for 0 msecs: init_posix_timers+0x0/0xc0()
<4>Calling initcall 0xc035bb6c: init_posix_cpu_timers+0x0/0xf0()
<4>initcall 0xc035bb6c: init_posix_cpu_timers+0x0/0xf0() returned 0.
<4>initcall 0xc035bb6c ran for 0 msecs: init_posix_cpu_timers+0x0/0xf0()
<4>Calling initcall 0xc035bd68: latency_init+0x0/0x40()
<4>initcall 0xc035bd68: latency_init+0x0/0x40() returned 0.
<4>initcall 0xc035bd68 ran for 0 msecs: latency_init+0x0/0x40()
<4>Calling initcall 0xc035bda8: nsproxy_cache_init+0x0/0x44()
<4>initcall 0xc035bda8: nsproxy_cache_init+0x0/0x44() returned 0.
<4>initcall 0xc035bda8 ran for 0 msecs: nsproxy_cache_init+0x0/0x44()
<4>Calling initcall 0xc035bdec: timekeeping_init_device+0x0/0x44()
<4>initcall 0xc035bdec: timekeeping_init_device+0x0/0x44() returned 0.
<4>initcall 0xc035bdec ran for 0 msecs: timekeeping_init_device+0x0/0x44()
<4>Calling initcall 0xc035c07c: init_clocksource_sysfs+0x0/0x80()
<4>initcall 0xc035c07c: init_clocksource_sysfs+0x0/0x80() returned 0.
<4>initcall 0xc035c07c ran for 0 msecs: init_clocksource_sysfs+0x0/0x80()
<4>Calling initcall 0xc035c124: init_timer_list_procfs+0x0/0x4c()
<4>initcall 0xc035c124: init_timer_list_procfs+0x0/0x4c() returned 0.
<4>initcall 0xc035c124 ran for 0 msecs: init_timer_list_procfs+0x0/0x4c()
<4>Calling initcall 0xc035c210: init+0x0/0xa8()
<4>initcall 0xc035c210: init+0x0/0xa8() returned 0.
<4>initcall 0xc035c210 ran for 0 msecs: init+0x0/0xa8()
<4>Calling initcall 0xc035c2b8: proc_dma_init+0x0/0x48()
<4>initcall 0xc035c2b8: proc_dma_init+0x0/0x48() returned 0.
<4>initcall 0xc035c2b8 ran for 0 msecs: proc_dma_init+0x0/0x48()
<4>Calling initcall 0xc035c300: kallsyms_init+0x0/0x48()
<4>initcall 0xc035c300: kallsyms_init+0x0/0x48() returned 0.
<4>initcall 0xc035c300 ran for 0 msecs: kallsyms_init+0x0/0x48()
<4>Calling initcall 0xc035c348: crash_notes_memory_init+0x0/0x5c()
<4>initcall 0xc035c348: crash_notes_memory_init+0x0/0x5c() returned 0.
<4>initcall 0xc035c348 ran for 0 msecs: crash_notes_memory_init+0x0/0x5c()
<4>Calling initcall 0xc035c3a4: crash_save_vmcoreinfo_init+0x0/0x348()
<4>initcall 0xc035c3a4: crash_save_vmcoreinfo_init+0x0/0x348() returned 0.
<4>initcall 0xc035c3a4 ran for 0 msecs: crash_save_vmcoreinfo_init+0x0/0x348()
<4>Calling initcall 0xc035ca88: audit_init+0x0/0x144()
<6>audit: initializing netlink socket (disabled)
<5>audit(0.384:1): initialized
<4>initcall 0xc035ca88: audit_init+0x0/0x144() returned 0.
<4>initcall 0xc035ca88 ran for 0 msecs: audit_init+0x0/0x144()
<4>Calling initcall 0xc035cc90: audit_tree_init+0x0/0x6c()
<4>initcall 0xc035cc90: audit_tree_init+0x0/0x6c() returned 0.
<4>initcall 0xc035cc90 ran for 0 msecs: audit_tree_init+0x0/0x6c()
<4>Calling initcall 0xc035ce14: relay_init+0x0/0x8()
<4>initcall 0xc035ce14: relay_init+0x0/0x8() returned 0.
<4>initcall 0xc035ce14 ran for 0 msecs: relay_init+0x0/0x8()
<4>Calling initcall 0xc035ce1c: utsname_sysctl_init+0x0/0x2c()
<4>initcall 0xc035ce1c: utsname_sysctl_init+0x0/0x2c() returned 0.
<4>initcall 0xc035ce1c ran for 0 msecs: utsname_sysctl_init+0x0/0x2c()
<4>Calling initcall 0xc035e1b0: init_per_zone_pages_min+0x0/0x5c()
<4>initcall 0xc035e1b0: init_per_zone_pages_min+0x0/0x5c() returned 0.
<4>initcall 0xc035e1b0 ran for 0 msecs: init_per_zone_pages_min+0x0/0x5c()
<4>Calling initcall 0xc035ef7c: pdflush_init+0x0/0x3c()
<4>initcall 0xc035ef7c: pdflush_init+0x0/0x3c() returned 0.
<4>initcall 0xc035ef7c ran for 0 msecs: pdflush_init+0x0/0x3c()
<4>Calling initcall 0xc035f038: kswapd_init+0x0/0x2c()
<4>initcall 0xc035f038: kswapd_init+0x0/0x2c() returned 0.
<4>initcall 0xc035f038 ran for 0 msecs: kswapd_init+0x0/0x2c()
<4>Calling initcall 0xc035f134: init_emergency_pool+0x0/0x88()
<4>highmem bounce pool size: 64 pages
<4>initcall 0xc035f134: init_emergency_pool+0x0/0x88() returned 0.
<4>initcall 0xc035f134 ran for 0 msecs: init_emergency_pool+0x0/0x88()
<4>Calling initcall 0xc035f1bc: procswaps_init+0x0/0x48()
<4>initcall 0xc035f1bc: procswaps_init+0x0/0x48() returned 0.
<4>initcall 0xc035f1bc ran for 0 msecs: procswaps_init+0x0/0x48()
<4>Calling initcall 0xc035f204: init_tmpfs+0x0/0xf0()
<4>initcall 0xc035f204: init_tmpfs+0x0/0xf0() returned 0.
<4>initcall 0xc035f204 ran for 0 msecs: init_tmpfs+0x0/0xf0()
<4>Calling initcall 0xc035f4ec: slab_sysfs_init+0x0/0x100()
<4>initcall 0xc035f4ec: slab_sysfs_init+0x0/0x100() returned 0.
<4>initcall 0xc035f4ec ran for 4 msecs: slab_sysfs_init+0x0/0x100()
<4>Calling initcall 0xc035f860: fasync_init+0x0/0x44()
<4>initcall 0xc035f860: fasync_init+0x0/0x44() returned 0.
<4>initcall 0xc035f860 ran for 0 msecs: fasync_init+0x0/0x44()
<4>Calling initcall 0xc035ff30: aio_setup+0x0/0x94()
<4>initcall 0xc035ff30: aio_setup+0x0/0x94() returned 0.
<4>initcall 0xc035ff30 ran for 0 msecs: aio_setup+0x0/0x94()
<4>Calling initcall 0xc03601bc: inotify_setup+0x0/0x14()
<4>initcall 0xc03601bc: inotify_setup+0x0/0x14() returned 0.
<4>initcall 0xc03601bc ran for 0 msecs: inotify_setup+0x0/0x14()
<4>Calling initcall 0xc03601d0: inotify_user_setup+0x0/0xe8()
<4>initcall 0xc03601d0: inotify_user_setup+0x0/0xe8() returned 0.
<4>initcall 0xc03601d0 ran for 0 msecs: inotify_user_setup+0x0/0xe8()
<4>Calling initcall 0xc03604c8: init_mbcache+0x0/0x2c()
<4>initcall 0xc03604c8: init_mbcache+0x0/0x2c() returned 0.
<4>initcall 0xc03604c8 ran for 0 msecs: init_mbcache+0x0/0x2c()
<4>Calling initcall 0xc03604f4: dquot_init+0x0/0x114()
<5>VFS: Disk quotas dquot_6.5.1
<4>Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
<4>initcall 0xc03604f4: dquot_init+0x0/0x114() returned 0.
<4>initcall 0xc03604f4 ran for 0 msecs: dquot_init+0x0/0x114()
<4>Calling initcall 0xc0360608: dnotify_init+0x0/0x44()
<4>initcall 0xc0360608: dnotify_init+0x0/0x44() returned 0.
<4>initcall 0xc0360608 ran for 0 msecs: dnotify_init+0x0/0x44()
<4>Calling initcall 0xc0360cb4: init_devpts_fs+0x0/0x64()
<4>initcall 0xc0360cb4: init_devpts_fs+0x0/0x64() returned 0.
<4>initcall 0xc0360cb4 ran for 0 msecs: init_devpts_fs+0x0/0x64()
<4>Calling initcall 0xc0360d18: init_ext3_fs+0x0/0x8c()
<4>initcall 0xc0360d18: init_ext3_fs+0x0/0x8c() returned 0.
<4>initcall 0xc0360d18 ran for 0 msecs: init_ext3_fs+0x0/0x8c()
<4>Calling initcall 0xc0360ea4: journal_init+0x0/0xc8()
<4>initcall 0xc0360ea4: journal_init+0x0/0xc8() returned 0.
<4>initcall 0xc0360ea4 ran for 0 msecs: journal_init+0x0/0xc8()
<4>Calling initcall 0xc0360f6c: init_ext2_fs+0x0/0x8c()
<4>initcall 0xc0360f6c: init_ext2_fs+0x0/0x8c() returned 0.
<4>initcall 0xc0360f6c ran for 0 msecs: init_ext2_fs+0x0/0x8c()
<4>Calling initcall 0xc0361054: init_cramfs_fs+0x0/0x4c()
<4>initcall 0xc0361054: init_cramfs_fs+0x0/0x4c() returned 0.
<4>initcall 0xc0361054 ran for 0 msecs: init_cramfs_fs+0x0/0x4c()
<4>Calling initcall 0xc03610a0: init_ramfs_fs+0x0/0x28()
<4>initcall 0xc03610a0: init_ramfs_fs+0x0/0x28() returned 0.
<4>initcall 0xc03610a0 ran for 0 msecs: init_ramfs_fs+0x0/0x28()
<4>Calling initcall 0xc036118c: ipc_init+0x0/0x2c()
<4>initcall 0xc036118c: ipc_init+0x0/0x2c() returned 0.
<4>initcall 0xc036118c ran for 0 msecs: ipc_init+0x0/0x2c()
<4>Calling initcall 0xc0361338: ipc_sysctl_init+0x0/0x2c()
<4>initcall 0xc0361338: ipc_sysctl_init+0x0/0x2c() returned 0.
<4>initcall 0xc0361338 ran for 0 msecs: ipc_sysctl_init+0x0/0x2c()
<4>Calling initcall 0xc0361364: init_mqueue_fs+0x0/0xe8()
<4>initcall 0xc0361364: init_mqueue_fs+0x0/0xe8() returned 0.
<4>initcall 0xc0361364 ran for 0 msecs: init_mqueue_fs+0x0/0xe8()
<4>Calling initcall 0xc03615dc: key_proc_init+0x0/0x54()
<4>initcall 0xc03615dc: key_proc_init+0x0/0x54() returned 0.
<4>initcall 0xc03615dc ran for 0 msecs: key_proc_init+0x0/0x54()
<4>Calling initcall 0xc0361798: selinux_nf_ip_init+0x0/0x80()
<4>initcall 0xc0361798: selinux_nf_ip_init+0x0/0x80() returned 0.
<4>initcall 0xc0361798 ran for 0 msecs: selinux_nf_ip_init+0x0/0x80()
<4>Calling initcall 0xc03619bc: init_sel_fs+0x0/0x90()
<4>initcall 0xc03619bc: init_sel_fs+0x0/0x90() returned 0.
<4>initcall 0xc03619bc ran for 0 msecs: init_sel_fs+0x0/0x90()
<4>Calling initcall 0xc0361ac4: selnl_init+0x0/0x68()
<4>initcall 0xc0361ac4: selnl_init+0x0/0x68() returned 0.
<4>initcall 0xc0361ac4 ran for 0 msecs: selnl_init+0x0/0x68()
<4>Calling initcall 0xc0361b2c: sel_netif_init+0x0/0x94()
<4>initcall 0xc0361b2c: sel_netif_init+0x0/0x94() returned 0.
<4>initcall 0xc0361b2c ran for 0 msecs: sel_netif_init+0x0/0x94()
<4>Calling initcall 0xc0361bc0: aurule_init+0x0/0x50()
<4>initcall 0xc0361bc0: aurule_init+0x0/0x50() returned 0.
<4>initcall 0xc0361bc0 ran for 0 msecs: aurule_init+0x0/0x50()
<4>Calling initcall 0xc0361cdc: crypto_algapi_init+0x0/0x24()
<4>initcall 0xc0361cdc: crypto_algapi_init+0x0/0x24() returned 0.
<4>initcall 0xc0361cdc ran for 0 msecs: crypto_algapi_init+0x0/0x24()
<4>Calling initcall 0xc0361d44: cryptomgr_init+0x0/0x28()
<4>initcall 0xc0361d44: cryptomgr_init+0x0/0x28() returned 0.
<4>initcall 0xc0361d44 ran for 0 msecs: cryptomgr_init+0x0/0x28()
<4>Calling initcall 0xc0361d6c: hmac_module_init+0x0/0x28()
<4>initcall 0xc0361d6c: hmac_module_init+0x0/0x28() returned 0.
<4>initcall 0xc0361d6c ran for 0 msecs: hmac_module_init+0x0/0x28()
<4>Calling initcall 0xc0361d94: init+0x0/0x28()
<4>initcall 0xc0361d94: init+0x0/0x28() returned 0.
<4>initcall 0xc0361d94 ran for 0 msecs: init+0x0/0x28()
<4>Calling initcall 0xc036213c: noop_init+0x0/0x2c()
<6>io scheduler noop registered
<4>initcall 0xc036213c: noop_init+0x0/0x2c() returned 0.
<4>initcall 0xc036213c ran for 0 msecs: noop_init+0x0/0x2c()
<4>Calling initcall 0xc0362168: as_init+0x0/0x2c()
<6>io scheduler anticipatory registered
<4>initcall 0xc0362168: as_init+0x0/0x2c() returned 0.
<4>initcall 0xc0362168 ran for 0 msecs: as_init+0x0/0x2c()
<4>Calling initcall 0xc0362194: deadline_init+0x0/0x2c()
<6>io scheduler deadline registered
<4>initcall 0xc0362194: deadline_init+0x0/0x2c() returned 0.
<4>initcall 0xc0362194 ran for 0 msecs: deadline_init+0x0/0x2c()
<4>Calling initcall 0xc03621c0: cfq_init+0x0/0xc8()
<6>io scheduler cfq registered (default)
<4>initcall 0xc03621c0: cfq_init+0x0/0xc8() returned 0.
<4>initcall 0xc03621c0 ran for 0 msecs: cfq_init+0x0/0xc8()
<4>Calling initcall 0xc0136270: pci_init+0x0/0x50()
<4>initcall 0xc0136270: pci_init+0x0/0x50() returned 0.
<4>initcall 0xc0136270 ran for 0 msecs: pci_init+0x0/0x50()
<4>Calling initcall 0xc0362b54: pci_proc_init+0x0/0x9c()
<4>initcall 0xc0362b54: pci_proc_init+0x0/0x9c() returned 0.
<4>initcall 0xc0362b54 ran for 0 msecs: pci_proc_init+0x0/0x9c()
<4>Calling initcall 0xc0362bf0: pcie_portdrv_init+0x0/0x6c()
<4>initcall 0xc0362bf0: pcie_portdrv_init+0x0/0x6c() returned 0.
<4>initcall 0xc0362bf0 ran for 0 msecs: pcie_portdrv_init+0x0/0x6c()
<4>Calling initcall 0xc0362c5c: aer_service_init+0x0/0x44()
<4>initcall 0xc0362c5c: aer_service_init+0x0/0x44() returned 0.
<4>initcall 0xc0362c5c ran for 0 msecs: aer_service_init+0x0/0x44()
<4>Calling initcall 0xc0362fa8: fb_console_init+0x0/0x184()
<4>initcall 0xc0362fa8: fb_console_init+0x0/0x184() returned 0.
<4>initcall 0xc0362fa8 ran for 0 msecs: fb_console_init+0x0/0x184()
<4>Calling initcall 0xc0363438: radeonfb_init+0x0/0x220()
<4>radeonfb (0000:01:00.0): Cannot match card to OF node !
<6>radeonfb: Found Intel x86 BIOS ROM Image
<6>radeonfb: Retrieved PLL infos from BIOS
<4>radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=250.00 Mhz, System=200.00 MHz
<4>radeonfb: PLL min 20000 max 40000
<4>i2c-adapter i2c-2: unable to read EDID block.
<4>i2c-adapter i2c-2: unable to read EDID block.
<4>i2c-adapter i2c-2: unable to read EDID block.
<4>i2c-adapter i2c-3: unable to read EDID block.
<4>i2c-adapter i2c-3: unable to read EDID block.
<4>i2c-adapter i2c-3: unable to read EDID block.
<6>radeonfb: Monitor 1 type DFP found
<6>radeonfb: EDID probed
<6>radeonfb: Monitor 2 type no found
<4>Console: switching to colour frame buffer device 200x75
<4>radeonfb (0000:01:00.0): ATI Radeon Ya 
<4>initcall 0xc0363438: radeonfb_init+0x0/0x220() returned 0.
<4>initcall 0xc0363438 ran for 4492 msecs: radeonfb_init+0x0/0x220()
<4>Calling initcall 0xc0363850: vga16fb_init+0x0/0xdc()
<7>vga16fb: initializing
<6>vga16fb: mapped to 0x000a0000
<6>fb1: VGA16 VGA frame buffer device
<4>initcall 0xc0363850: vga16fb_init+0x0/0xdc() returned 0.
<4>initcall 0xc0363850 ran for 0 msecs: vga16fb_init+0x0/0xdc()
<4>Calling initcall 0xc0363a38: rand_initialize+0x0/0x44()
<4>initcall 0xc0363a38: rand_initialize+0x0/0x44() returned 0.
<4>initcall 0xc0363a38 ran for 0 msecs: rand_initialize+0x0/0x44()
<4>Calling initcall 0xc0363adc: tty_init+0x0/0x208()
<4>initcall 0xc0363adc: tty_init+0x0/0x208() returned 0.
<4>initcall 0xc0363adc ran for 5 msecs: tty_init+0x0/0x208()
<4>Calling initcall 0xc0363d28: pty_init+0x0/0x3bc()
<4>initcall 0xc0363d28: pty_init+0x0/0x3bc() returned 0.
<4>initcall 0xc0363d28 ran for 2 msecs: pty_init+0x0/0x3bc()
<4>Calling initcall 0xc0364834: rtc_generic_init+0x0/0x98()
<6>Generic RTC Driver v1.07
<4>initcall 0xc0364834: rtc_generic_init+0x0/0x98() returned 0.
<4>initcall 0xc0364834 ran for 0 msecs: rtc_generic_init+0x0/0x98()
<4>Calling initcall 0xc0364d18: serial8250_init+0x0/0x138()
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
<6>serial8250.0: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
<6>console [ttyS0] enabled
<6>serial8250.0: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
<4>initcall 0xc0364d18: serial8250_init+0x0/0x138() returned 0.
<4>initcall 0xc0364d18 ran for 24626 msecs: serial8250_init+0x0/0x138()
<4>Calling initcall 0xc0364e80: serial8250_pci_init+0x0/0x34()
<4>initcall 0xc0364e80: serial8250_pci_init+0x0/0x34() returned 0.
<4>initcall 0xc0364e80 ran for 0 msecs: serial8250_pci_init+0x0/0x34()
<4>Calling initcall 0xc03653a4: parport_default_proc_register+0x0/0x3c()
<4>initcall 0xc03653a4: parport_default_proc_register+0x0/0x3c() returned 0.
<4>initcall 0xc03653a4 ran for 0 msecs: parport_default_proc_register+0x0/0x3c()
<4>Calling initcall 0xc036577c: parport_pc_init+0x0/0x214()
<7>parport_pc: VIA 686A/8231 detected
<7>parport_pc: probing current configuration
<7>parport_pc: Current parallel port base: 0x378
<6>parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
<6>parport_pc: VIA parallel port: io=0x378
<4>initcall 0xc036577c: parport_pc_init+0x0/0x214() returned 0.
<4>initcall 0xc036577c ran for 140 msecs: parport_pc_init+0x0/0x214()
<4>Calling initcall 0xc0365990: parport_serial_init+0x0/0x34()
<4>initcall 0xc0365990: parport_serial_init+0x0/0x34() returned 0.
<4>initcall 0xc0365990 ran for 0 msecs: parport_serial_init+0x0/0x34()
<4>Calling initcall 0xc0365eec: floppy_init+0x0/0x1050()
<6>Floppy drive(s): fd0 is 2.88M
<6>FDC 0 is a post-1991 82077
<4>initcall 0xc0365eec: floppy_init+0x0/0x1050() returned 0.
<4>initcall 0xc0365eec ran for 35 msecs: floppy_init+0x0/0x1050()
<4>Calling initcall 0xc0366fa4: rd_init+0x0/0x23c()
<4>RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
<4>initcall 0xc0366fa4: rd_init+0x0/0x23c() returned 0.
<4>initcall 0xc0366fa4 ran for 13 msecs: rd_init+0x0/0x23c()
<4>Calling initcall 0xc03671e0: vortex_init+0x0/0xe0()
<4>3c59x: Donald Becker and others.
<6>0000:00:06.0: 3Com PCI 3c905C Tornado at f100c000.
<4>initcall 0xc03671e0: vortex_init+0x0/0xe0() returned 0.
<4>initcall 0xc03671e0 ran for 40 msecs: vortex_init+0x0/0xe0()
<4>Calling initcall 0xc0367354: net_olddevs_init+0x0/0xe0()
<4>initcall 0xc0367354: net_olddevs_init+0x0/0xe0() returned 0.
<4>initcall 0xc0367354 ran for 0 msecs: net_olddevs_init+0x0/0xe0()
<4>Calling initcall 0xc03674f0: cp_init+0x0/0x34()
<4>initcall 0xc03674f0: cp_init+0x0/0x34() returned 0.
<4>initcall 0xc03674f0 ran for 0 msecs: cp_init+0x0/0x34()
<4>Calling initcall 0xc0367524: it8213_ide_init+0x0/0x34()
<4>initcall 0xc0367524: it8213_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc0367524 ran for 0 msecs: it8213_ide_init+0x0/0x34()
<4>Calling initcall 0xc0367558: it821x_ide_init+0x0/0x34()
<4>initcall 0xc0367558: it821x_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc0367558 ran for 0 msecs: it821x_ide_init+0x0/0x34()
<4>Calling initcall 0xc036758c: pdc202xx_ide_init+0x0/0x34()
<4>initcall 0xc036758c: pdc202xx_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc036758c ran for 0 msecs: pdc202xx_ide_init+0x0/0x34()
<4>Calling initcall 0xc03675c0: pdc202new_ide_init+0x0/0x34()
<4>initcall 0xc03675c0: pdc202new_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc03675c0 ran for 0 msecs: pdc202new_ide_init+0x0/0x34()
<4>Calling initcall 0xc03675f4: siimage_ide_init+0x0/0x34()
<4>initcall 0xc03675f4: siimage_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc03675f4 ran for 0 msecs: siimage_ide_init+0x0/0x34()
<4>Calling initcall 0xc0367628: via_ide_init+0x0/0x34()
<4>initcall 0xc0367628: via_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc0367628 ran for 0 msecs: via_ide_init+0x0/0x34()
<4>Calling initcall 0xc036765c: generic_ide_init+0x0/0x34()
<4>initcall 0xc036765c: generic_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc036765c ran for 0 msecs: generic_ide_init+0x0/0x34()
<4>Calling initcall 0xc0367740: ide_init+0x0/0x80()
<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<6>VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:07.1
<6>VP_IDE: not 100% native mode: will probe irqs later
<6>VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
<6>    ide0: BM-DMA at 0xcc00-0xcc07, BIOS settings: hda:pio, hdb:pio
<6>    ide1: BM-DMA at 0xcc08-0xcc0f, BIOS settings: hdc:pio, hdd:pio
<7>Probing IDE interface ide0...
<4>hda: ST380011A, ATA DISK drive
<7>hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
<6>hda: UDMA/100 mode selected
<4>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<7>Probing IDE interface ide1...
<4>hdd: LITE-ON LTR-52327S, ATAPI CD/DVD-ROM drive
<4>hdc: TOSHIBA ODD-DVD SD-M1802, ATAPI CD/DVD-ROM drive
<7>hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
<6>hdc: UDMA/33 mode selected
<7>hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
<6>hdd: UDMA/33 mode selected
<4>ide1 at 0x170-0x177,0x376 on irq 15
<4>initcall 0xc0367740: ide_init+0x0/0x80() returned 0.
<4>initcall 0xc0367740 ran for 8919 msecs: ide_init+0x0/0x80()
<4>Calling initcall 0xc03680ec: idedisk_init+0x0/0x28()
<6>hda: max request size: 512KiB
<6>hda: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63
<6>hda: cache flushes supported
<6> hda: RDSK (512) hda1 (SFS^@)(res 2 spb 1) hda2 (LNX^@)(res 2 spb 2) hda3 (LNX^@)(res 2 spb 2) hda4 (LNX^@)(res 2 spb 2) hda5 (LNX^@)(res 2 spb 2) hda6 (SWP^@)(res 2 spb 2) hda7 (LNX^@)(res 2 spb 2) hda8 (DOS^C)(res 2 spb 2) hda9 (SFS^@)(res 2 spb 1) hda10 (SFS^@)(res 2 spb 1) hda11 (LNX^@)(res 2 spb 2) hda12 (LNX^@)(res 2 spb 2)
<4>initcall 0xc03680ec: idedisk_init+0x0/0x28() returned 0.
<4>initcall 0xc03680ec ran for 82 msecs: idedisk_init+0x0/0x28()
<4>Calling initcall 0xc0368114: ide_cdrom_init+0x0/0x28()
<6>hdc: ATAPI 48X DVD-ROM drive, 256kB Cache
<6>Uniform CD-ROM driver Revision: 3.20
<6>hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
<4>initcall 0xc0368114: ide_cdrom_init+0x0/0x28() returned 0.
<4>initcall 0xc0368114 ran for 40 msecs: ide_cdrom_init+0x0/0x28()
<4>Calling initcall 0xc0368548: via_init+0x0/0x34()
<4>initcall 0xc0368548: via_init+0x0/0x34() returned 0.
<4>initcall 0xc0368548 ran for 0 msecs: via_init+0x0/0x34()
<4>Calling initcall 0xc036857c: ieee1394_init+0x0/0x280()
<4>initcall 0xc036857c: ieee1394_init+0x0/0x280() returned 0.
<4>initcall 0xc036857c ran for 0 msecs: ieee1394_init+0x0/0x280()
<4>Calling initcall 0xc03687fc: cdrom_init+0x0/0x24()
<4>initcall 0xc03687fc: cdrom_init+0x0/0x24() returned 0.
<4>initcall 0xc03687fc ran for 0 msecs: cdrom_init+0x0/0x24()
<4>Calling initcall 0xc03688c4: i8042_init+0x0/0x128()
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>serio: i8042 AUX port at 0x60,0x64 irq 12
<4>initcall 0xc03688c4: i8042_init+0x0/0x128() returned 0.
<4>initcall 0xc03688c4 ran for 21 msecs: i8042_init+0x0/0x128()
<4>Calling initcall 0xc0368b28: mousedev_init+0x0/0xb4()
<6>mice: PS/2 mouse device common for all mice
<4>initcall 0xc0368b28: mousedev_init+0x0/0xb4() returned 0.
<4>initcall 0xc0368b28 ran for 11 msecs: mousedev_init+0x0/0xb4()
<4>Calling initcall 0xc0368bdc: atkbd_init+0x0/0x34()
<4>initcall 0xc0368bdc: atkbd_init+0x0/0x34() returned 0.
<4>initcall 0xc0368bdc ran for 0 msecs: atkbd_init+0x0/0x34()
<4>Calling initcall 0xc0368c10: psmouse_init+0x0/0x94()
<6>input: AT Translated Set 2 keyboard as /class/input/input0
<4>initcall 0xc0368c10: psmouse_init+0x0/0x94() returned 0.
<4>initcall 0xc0368c10 ran for 926 msecs: psmouse_init+0x0/0x94()
<4>Calling initcall 0xc0368ed0: cmos_init+0x0/0x30()
<7>rtc_cmos: dev (254:0)
<6>rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
<6>rtc0: alarms up to one day
<6>input: ImPS/2 Generic Wheel Mouse as /class/input/input1
<4>initcall 0xc0368ed0: cmos_init+0x0/0x30() returned 0.
<4>initcall 0xc0368ed0 ran for 651 msecs: cmos_init+0x0/0x30()
<4>Calling initcall 0xc03693f4: i2c_dev_init+0x0/0xbc()
<6>i2c /dev entries driver
<4>initcall 0xc03693f4: i2c_dev_init+0x0/0xbc() returned 0.
<4>initcall 0xc03693f4 ran for 9 msecs: i2c_dev_init+0x0/0xbc()
<4>Calling initcall 0xc0369514: edac_init+0x0/0xc4()
<6>EDAC MC: Ver: 2.1.0 Jan 27 2008
<4>initcall 0xc0369514: edac_init+0x0/0xc4() returned 0.
<4>initcall 0xc0369514 ran for 9 msecs: edac_init+0x0/0xc4()
<4>Calling initcall 0xc0369634: cpufreq_stats_init+0x0/0x70()
<4>initcall 0xc0369634: cpufreq_stats_init+0x0/0x70() returned 0.
<4>initcall 0xc0369634 ran for 0 msecs: cpufreq_stats_init+0x0/0x70()
<4>Calling initcall 0xc03696cc: ledtrig_ide_init+0x0/0x34()
<4>initcall 0xc03696cc: ledtrig_ide_init+0x0/0x34() returned 0.
<4>initcall 0xc03696cc ran for 0 msecs: ledtrig_ide_init+0x0/0x34()
<4>Calling initcall 0xc0369700: hid_init+0x0/0x8()
<4>initcall 0xc0369700: hid_init+0x0/0x8() returned 0.
<4>initcall 0xc0369700 ran for 0 msecs: hid_init+0x0/0x8()
<4>Calling initcall 0xc0369708: init_soundcore+0x0/0x7c()
<4>initcall 0xc0369708: init_soundcore+0x0/0x7c() returned 0.
<4>initcall 0xc0369708 ran for 0 msecs: init_soundcore+0x0/0x7c()
<4>Calling initcall 0xc036a0f4: flow_cache_init+0x0/0x150()
<4>initcall 0xc036a0f4: flow_cache_init+0x0/0x150() returned 0.
<4>initcall 0xc036a0f4 ran for 0 msecs: flow_cache_init+0x0/0x150()
<4>Calling initcall 0xc036a3c8: blackhole_module_init+0x0/0x28()
<4>initcall 0xc036a3c8: blackhole_module_init+0x0/0x28() returned 0.
<4>initcall 0xc036a3c8 ran for 0 msecs: blackhole_module_init+0x0/0x28()
<4>Calling initcall 0xc036bb48: init_syncookies+0x0/0x30()
<4>initcall 0xc036bb48: init_syncookies+0x0/0x30() returned 0.
<4>initcall 0xc036bb48 ran for 0 msecs: init_syncookies+0x0/0x30()
<4>Calling initcall 0xc036bb78: xfrm4_beet_init+0x0/0x2c()
<4>initcall 0xc036bb78: xfrm4_beet_init+0x0/0x2c() returned 0.
<4>initcall 0xc036bb78 ran for 0 msecs: xfrm4_beet_init+0x0/0x2c()
<4>Calling initcall 0xc02879d4: ipv4_netfilter_init+0x0/0x28()
<4>initcall 0xc02879d4: ipv4_netfilter_init+0x0/0x28() returned 0.
<4>initcall 0xc02879d4 ran for 0 msecs: ipv4_netfilter_init+0x0/0x28()
<4>Calling initcall 0xc036bba4: bictcp_register+0x0/0x28()
<6>TCP bic registered
<4>initcall 0xc036bba4: bictcp_register+0x0/0x28() returned 0.
<4>initcall 0xc036bba4 ran for 7 msecs: bictcp_register+0x0/0x28()
<4>Calling initcall 0xc036be24: af_unix_init+0x0/0x88()
<6>NET: Registered protocol family 1
<4>initcall 0xc036be24: af_unix_init+0x0/0x88() returned 0.
<4>initcall 0xc036be24 ran for 9 msecs: af_unix_init+0x0/0x88()
<4>Calling initcall 0xc036beac: packet_init+0x0/0x78()
<6>NET: Registered protocol family 17
<4>initcall 0xc036beac: packet_init+0x0/0x78() returned 0.
<4>initcall 0xc036beac ran for 9 msecs: packet_init+0x0/0x78()
<4>Calling initcall 0xc036c130: atm_clip_init+0x0/0xb4()
<4>initcall 0xc036c130: atm_clip_init+0x0/0xb4() returned 0.
<4>initcall 0xc036c130 ran for 0 msecs: atm_clip_init+0x0/0xb4()
<4>Calling initcall 0xc03548a4: check_cache_coherency+0x0/0x80()
<4>initcall 0xc03548a4: check_cache_coherency+0x0/0x80() returned 0.
<4>initcall 0xc03548a4 ran for 0 msecs: check_cache_coherency+0x0/0x80()
<4>Calling initcall 0xc001bac0: init_oops_id+0x0/0x40()
<4>initcall 0xc001bac0: init_oops_id+0x0/0x40() returned 0.
<4>initcall 0xc001bac0 ran for 0 msecs: init_oops_id+0x0/0x40()
<4>Calling initcall 0xc035a9b4: disable_boot_consoles+0x0/0x6c()
<4>initcall 0xc035a9b4: disable_boot_consoles+0x0/0x6c() returned 0.
<4>initcall 0xc035a9b4 ran for 0 msecs: disable_boot_consoles+0x0/0x6c()
<4>Calling initcall 0xc0362420: random32_reseed+0x0/0x3c()
<4>initcall 0xc0362420: random32_reseed+0x0/0x3c() returned 0.
<4>initcall 0xc0362420 ran for 0 msecs: random32_reseed+0x0/0x3c()
<4>Calling initcall 0xc0362ae4: pci_sysfs_init+0x0/0x70()
<4>initcall 0xc0362ae4: pci_sysfs_init+0x0/0x70() returned 0.
<4>initcall 0xc0362ae4 ran for 0 msecs: pci_sysfs_init+0x0/0x70()
<4>Calling initcall 0xc0363a10: seqgen_init+0x0/0x28()
<4>initcall 0xc0363a10: seqgen_init+0x0/0x28() returned 0.
<4>initcall 0xc0363a10 ran for 0 msecs: seqgen_init+0x0/0x28()
<4>Calling initcall 0xc01d04d8: scsi_complete_async_scans+0x0/0xf0()
<4>initcall 0xc01d04d8: scsi_complete_async_scans+0x0/0xf0() returned 0.
<4>initcall 0xc01d04d8 ran for 0 msecs: scsi_complete_async_scans+0x0/0xf0()
<4>Calling initcall 0xc0368ca4: rtc_hctosys+0x0/0x140()
<6>rtc_cmos rtc_cmos: setting system clock to 2008-02-05 21:44:36 UTC (1202247876)
<4>initcall 0xc0368ca4: rtc_hctosys+0x0/0x140() returned 0.
<4>initcall 0xc0368ca4 ran for 13 msecs: rtc_hctosys+0x0/0x140()
<4>Calling initcall 0xc036b0f8: tcp_congestion_default+0x0/0xc()
<4>initcall 0xc036b0f8: tcp_congestion_default+0x0/0xc() returned 0.
<4>initcall 0xc036b0f8 ran for 0 msecs: tcp_congestion_default+0x0/0xc()
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs: mounted filesystem with ordered data mode.
<4>VFS: Mounted root (ext3 filesystem) readonly.
<4>Freeing unused kernel memory: 176k init
<4>Calling INIT

--========GMX220631202253421230786
Content-Type: text/x-log;
 charset="iso-8859-15";
 name="kernel-oopsmemoption.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="kernel-oopsmemoption.log"

<1>Unable to handle kernel paging request for data at address 0xbffff000
<1>Faulting instruction address: 0xc0015d88
<4>Oops: Kernel access of bad area, sig: 11 [#1]
<4>
<4>Modules linked in:
<4>NIP: c0015d88 LR: c030d124 CTR: 000001d0
<4>REGS: c0357f00 TRAP: 0300   Not tainted  (2.6.24)
<4>MSR: 00002030
<FP,IR,DR>  CR: 24024048  XER: 20000000
<4>DAR: bffff000, DSISR: 42000000
<4>TASK = c0332570[0] 'swapper' THREAD: c0356000
<6>GPR00: 00000000 c0357fb0 c0332570 bffff000 c0b8f3a4 00000e80 bfffeffc d00dfeed 
<6>GPR08: 00000e80 00000002 c035fff4 ffffffff 44024044 00000000 0ffd5900 00800450 
<6>GPR16: 00000001 ffffffff 00000000 007ffc00 0ffd3158 0f0689b0 0ffff220 007ffbc0 
<6>GPR24: 00000000 00000000 40000000 00000000 00000e80 bffff000 c0360000 00000e80 
<4>NIP [c0015d88] memcpy+0x24/0x9c
<4>LR [c030d124] early_init_devtree+0x18c/0x1b0
<4>Call Trace:
<4>[c0357fb0] [c030d110] early_init_devtree+0x178/0x1b0 (unreliable)
<4>[c0357fd0] [c030dcf4] machine_init+0x20/0x8c
<4>[c0357ff0] [c0003838] start_here+0x38/0x78
<4>Instruction dump:
<4>4e800020 7c032040 418100a0 54a7e8ff 38c3fffc 3884fffc 41820028 70c00003 
<4>7ce903a6 40820054 80e40004 85040008
<90e60004> 95060008 4200fff0 70a50007 
<4>---[ end trace 8640abe69a316dee ]---
<0>Kernel panic - not syncing: Attempted to kill the idle task!
<1>Unable to handle kernel paging request for instruction fetch
<1>Faulting instruction address: 0x00000000
<4>Oops: Kernel access of bad area, sig: 11 [#2]
<4>
<4>Modules linked in:
<4>NIP: 00000000 LR: c00067e8 CTR: 00000000
<4>REGS: c0357cc0 TRAP: 0400   Tainted: G      D  (2.6.24)
<4>MSR: 40001032
<ME,IR,DR>  CR: 48024082  XER: 00000000
<4>TASK = c0332570[0] 'swapper' THREAD: c0356000
<6>GPR00: c00067d8 c0357d70 c0332570 00000001 00000000 c0362174 ffffffff 00000000 
<6>GPR08: c03629f4 00000000 00001032 00010001 00000000 00000000 0ffd5900 00800450 
<6>GPR16: 00000001 ffffffff 00000000 007ffc00 0ffd3158 0f0689b0 0ffff220 007ffbc0 
<6>GPR24: 00000000 00000000 40000000 00000000 c02adae0 c0362174 c0332570 00000000 
<4>NIP [00000000] _start+0x40000000/0xc
<4>LR [c00067e8] do_IRQ+0x30/0xa8
<4>Call Trace:
<4>[c0357d70] [c00067d8] do_IRQ+0x20/0xa8 (unreliable)
<4>[c0357d80] [c0010e94] ret_from_except+0x0/0x14
<4>--- Exception: 501 at panic+0x130/0x164
<4>    LR = panic+0xa0/0x164
<4>[c0357e90] [c001fbb4] do_exit+0x64/0x710
<4>[c0357ec0] [c000e854] kernel_bad_stack+0x0/0x4c
<4>[c0357ee0] [c0013d54] bad_page_fault+0xb8/0xcc
<4>[c0357ef0] [c0010c88] handle_page_fault+0x7c/0x80
<4>--- Exception: 300 at memcpy+0x24/0x9c
<4>    LR = early_init_devtree+0x18c/0x1b0
<4>[c0357fb0] [c030d110] early_init_devtree+0x178/0x1b0 (unreliable)
<4>[c0357fd0] [c030dcf4] machine_init+0x20/0x8c
<4>[c0357ff0] [c0003838] start_here+0x38/0x78
<4>Instruction dump:
<4>XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
<4>XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
<0>Kernel panic - not syncing: Fatal exception in interrupt
<1>Unable to handle kernel paging request for instruction fetch
<1>Faulting instruction address: 0x00000000
<4>Oops: Kernel access of bad area, sig: 11 [#3]
<4>
<4>Modules linked in:
<4>NIP: 00000000 LR: c00067e8 CTR: 00000000
<4>REGS: c0357ab0 TRAP: 0400   Tainted: G      D  (2.6.24)
<4>MSR: 40001032
<ME,IR,DR>  CR: 48024082  XER: 00000000
<4>TASK = c0332570[0] 'swapper' THREAD: c0356000
<6>GPR00: c00067d8 c0357b60 c0332570 00000001 00000000 c0362174 ffffffff 00000000 
<6>GPR08: c03629f4 00000000 00001032 00020001 00000000 00000000 0ffd5900 00800450 
<6>GPR16: 00000001 ffffffff 00000000 007ffc00 0ffd3158 0f0689b0 0ffff220 007ffbc0 
<6>GPR24: 00000000 00000000 40000000 00000000 c02ab8fc c0362174 c02acdc4 c0357d90 
<4>NIP [00000000] _start+0x40000000/0xc
<4>LR [c00067e8] do_IRQ+0x30/0xa8
<4>Call Trace:
<4>[c0357b60] [c00067d8] do_IRQ+0x20/0xa8 (unreliable)
<4>[c0357b70] [c0010e94] ret_from_except+0x0/0x14
<4>--- Exception: 501 at panic+0x130/0x164
<4>    LR = panic+0xa0/0x164
<4>[c0357c80] [c000e848] die+0x154/0x160
<4>[c0357ca0] [c0013d54] bad_page_fault+0xb8/0xcc
<4>[c0357cb0] [c0010c88] handle_page_fault+0x7c/0x80
<4>--- Exception: 400 at _start+0x40000000/0xc
<4>    LR = do_IRQ+0x30/0xa8
<4>[c0357d70] [c00067d8] do_IRQ+0x20/0xa8 (unreliable)
<4>[c0357d80] [c0010e94] ret_from_except+0x0/0x14
<4>--- Exception: 501 at panic+0x130/0x164
<4>    LR = panic+0xa0/0x164
<4>[c0357e90] [c001fbb4] do_exit+0x64/0x710
<4>[c0357ec0] [c000e854] kernel_bad_stack+0x0/0x4c
<4>[c0357ee0] [c0013d54] bad_page_fault+0xb8/0xcc
<4>[c0357ef0] [c0010c88] handle_page_fault+0x7c/0x80
<4>--- Exception: 300 at memcpy+0x24/0x9c
<4>    LR = early_init_devtree+0x18c/0x1b0
<4>[c0357fb0] [c030d110] early_init_devtree+0x178/0x1b0 (unreliable)
<4>[c0357fd0] [c030dcf4] machine_init+0x20/0x8c
<4>[c0357ff0] [c0003838] start_here+0x38/0x78
<4>Instruction dump:
<4>XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
<4>XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
<0>Kernel panic - not syncing: Fatal exception in interrupt
<1>Unable to handle kernel paging request for instruction fetch
<1>Faulting instruction address: 0x00000000
<4>Oops: Kernel access of bad area, sig: 11 [#4]
<4>
<4>Modules linked in:
<4>NIP: 00000000 LR: c00067e8 CTR: 00000000
<4>REGS: c03578a0 TRAP: 0400   Tainted: G      D  (2.6.24)
<4>MSR: 40001032
<ME,IR,DR>  CR: 48024082  XER: 00000000
<4>TASK = c0332570[0] 'swapper' THREAD: c0356000
<6>GPR00: c00067d8 c0357950 c0332570 00000001 00000000 c0362174 ffffffff 00000000 
<6>GPR08: c03629f4 00000000 00001032 00030001 00000000 00000000 0ffd5900 00800450 
<6>GPR16: 00000001 ffffffff 00000000 007ffc00 0ffd3158 0f0689b0 0ffff220 007ffbc0 
<6>GPR24: 00000000 00000000 40000000 00000000 c02ab8fc c0362174 c02acdc4 c0357b80 
<4>NIP [00000000] _start+0x40000000/0xc
<4>LR [c00067e8] do_IRQ+0x30/0xa8
<4>Call Trace:
<4>[c0357950] [c00067d8] do_IRQ+0x20/0xa8 (unreliable)
<4>[c0357960] [c0010e94] ret_from_except+0x0/0x14
<4>--- Exception: 501 at panic+0x130/0x164
<4>    LR = panic+0xa0/0x164
<4>[c0357a70] [c000e848] die+0x154/0x160
<4>[c0357a90] [c0013d54] bad_page_fault+0xb8/0xcc
<4>[c0357aa0] [c0010c88] handle_page_fault+0x7c/0x80
<4>--- Exception: 400 at _start+0x40000000/0xc
<4>    LR = do_IRQ+0x30/0xa8
<4>[c0357b60] [c00067d8] do_IRQ+0x20/0xa8 (unreliable)
<4>[c0357b70] [c0010e94] ret_from_except+0x0/0x14
<4>--- Exception: 501 at panic+0x130/0x164
<4>    LR = panic+0xa0/0x164
<4>[c0357c80] [c000e848] die+0x154/0x160
<4>[c0357ca0] [c0013d54] bad_page_fault+0xb8/0xcc
<4>[c0357cb0] [c0010c88] handle_page_fault+0x7c/0x80
<4>--- Exception: 400 at _start+0x40000000/0xc
<4>    LR = do_IRQ+0x30/0xa8
<4>[c0357d70] [c00067d8] do_IRQ+0x20/0xa8 (unreliable)
<4>[c0357d80] [c0010e94] ret_from_except+0x0/0x14
<4>--- Exception: 501 at panic+0x130/0x164
<4>    LR = panic+0xa0/0x164
<4>[c0357e90] [c001fbb4] do_exit+0x64/0x710
<4>[c0357ec0] [c000e854] kernel_bad_stack+0x0/0x4c
<4>[c0357ee0] [c0013d54] bad_page_fault+0xb8/0xcc
<4>[c0357ef0] [c0010c88] handle_page_fault+0x7c/0x80
<4>--- Exception: 300 at memcpy+0x24/0x9c
<4>    LR = early_init_devtree+0x18c/0x1b0
<4>[c0357fb0] [c030d110] early_init_devtree+0x178/0x1b0 (unreliable)
<4>[c0357fd0] [c030dcf4] machine_init+0x20/0x8c
<4>[c0357ff0] [c0003838] start_here+0x38/0x78
<4>Instruction dump:
<4>XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
<4>XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX

--========GMX220631202253421230786
Content-Type: application/octet-stream; name="patch_amigaone_platform"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch_amigaone_platform"

Y29tbWl0IDBkZjAyZGU1YjRlNTgyYzIyOTYyMzYxY2E3MTA0Yzc1Yzc5NWRjMTUKQXV0aG9yOiBH
ZXJoYXJkIFBpcmNoZXIgPGdlcmhhcmRfcGlyY2hlckBnbXgubmV0PgpEYXRlOiAgIFdlZCBKYW4g
MzAgMjA6NTk6MjcgMjAwOCArMDEwMAoKICAgIEFkZCBzdXBwb3QgZm9yIEFtaWdhT25lIHBsYXRm
b3JtLgoKZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9ib290L01ha2VmaWxlIGIvYXJjaC9wb3dl
cnBjL2Jvb3QvTWFrZWZpbGUKaW5kZXggMThlMzI3MS4uYjg0OTgwOCAxMDA2NDQKLS0tIGEvYXJj
aC9wb3dlcnBjL2Jvb3QvTWFrZWZpbGUKKysrIGIvYXJjaC9wb3dlcnBjL2Jvb3QvTWFrZWZpbGUK
QEAgLTU2LDcgKzU2LDcgQEAgc3JjLXBsYXQgOj0gb2YuYyBjdWJvb3QtNTJ4eC5jIGN1Ym9vdC04
M3h4LmMgY3Vib290LTg1eHguYyBob2xseS5jIFwKIAkJY3Vib290LWVib255LmMgdHJlZWJvb3Qt
ZWJvbnkuYyBwcnBtYzI4MDAuYyBcCiAJCXBzMy1oZWFkLlMgcHMzLWh2Y2FsbC5TIHBzMy5jIHRy
ZWVib290LWJhbWJvby5jIGN1Ym9vdC04eHguYyBcCiAJCWN1Ym9vdC1wcTIuYyBjdWJvb3Qtc2Vx
dW9pYS5jIHRyZWVib290LXdhbG51dC5jIGN1Ym9vdC1iYW1ib28uYyBcCi0JCWZpeGVkLWhlYWQu
UyBlcDg4eGMuYyBjdWJvb3QtaHBjMi5jCisJCWZpeGVkLWhlYWQuUyBlcDg4eGMuYyBjdWJvb3Qt
aHBjMi5jIGN1Ym9vdC1hbWlnYW9uZS5jCiBzcmMtYm9vdCA6PSAkKHNyYy13bGliKSAkKHNyYy1w
bGF0KSBlbXB0eS5jCiAKIHNyYy1ib290IDo9ICQoYWRkcHJlZml4ICQob2JqKS8sICQoc3JjLWJv
b3QpKQpAQCAtMTU5LDYgKzE1OSw3IEBAIGltYWdlLSQoQ09ORklHX0VCT05ZKQkJCSs9IHRyZWVJ
bWFnZS5lYm9ueSBjdUltYWdlLmVib255CiBpbWFnZS0kKENPTkZJR19CQU1CT08pCQkJKz0gdHJl
ZUltYWdlLmJhbWJvbyBjdUltYWdlLmJhbWJvbwogaW1hZ2UtJChDT05GSUdfU0VRVU9JQSkJCQkr
PSBjdUltYWdlLnNlcXVvaWEKIGltYWdlLSQoQ09ORklHX1dBTE5VVCkJCQkrPSB0cmVlSW1hZ2Uu
d2FsbnV0CitpbWFnZS0kKENPTkZJR19BTUlHQU9ORSkJCSs9IGN1SW1hZ2UuYW1pZ2FvbmUKIGVu
ZGlmCiAKICMgRm9yIDMyLWJpdCBwb3dlcm1hY3MsIGJ1aWxkIHRoZSBDT0ZGIGFuZCBtaWJvb3Qg
aW1hZ2VzCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvYm9vdC9jdWJvb3QtYW1pZ2FvbmUuYyBi
L2FyY2gvcG93ZXJwYy9ib290L2N1Ym9vdC1hbWlnYW9uZS5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0
CmluZGV4IDAwMDAwMDAuLmQ5NWQ0ZDEKLS0tIC9kZXYvbnVsbAorKysgYi9hcmNoL3Bvd2VycGMv
Ym9vdC9jdWJvb3QtYW1pZ2FvbmUuYwpAQCAtMCwwICsxLDM2IEBACisvKgorICogT2xkIFUtYm9v
dCBjb21wYXRpYmlsaXR5IGZvciBBbWlnYU9uZQorICoKKyAqIEF1dGhvcjogR2VyaGFyZCBQaXJj
aGVyIChnZXJoYXJkX3BpcmNoZXJAZ214Lm5ldCkKKyAqCisgKiAgIEJhc2VkIG9uIGN1Ym9vdC04
M3h4LmMKKyAqIENvcHlyaWdodCAoYykgMjAwNyBGcmVlc2NhbGUgU2VtaWNvbmR1Y3RvciwgSW5j
LgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJp
YnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0CisgKiB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMiBhcyBwdWJsaXNoZWQKKyAqIGJ5IHRoZSBG
cmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uCisgKi8KKworI2luY2x1ZGUgIm9wcy5oIgorI2luY2x1
ZGUgInN0ZGlvLmgiCisjaW5jbHVkZSAiY3Vib290LmgiCisKKyNpbmNsdWRlICJwcGNib290Lmgi
CisKK3N0YXRpYyBiZF90IGJkOworZXh0ZXJuIGNoYXIgX2R0Yl9zdGFydFtdLCBfZHRiX2VuZFtd
OworCitzdGF0aWMgdm9pZCBwbGF0Zm9ybV9maXh1cHModm9pZCkKK3sKKwlkdF9maXh1cF9tZW1v
cnkoYmQuYmlfbWVtc3RhcnQsIGJkLmJpX21lbXNpemUpOworCWR0X2ZpeHVwX2NwdV9jbG9ja3Mo
YmQuYmlfaW50ZnJlcSwgYmQuYmlfYnVzZnJlcSAvIDQsIGJkLmJpX2J1c2ZyZXEpOworfQorCit2
b2lkIHBsYXRmb3JtX2luaXQodW5zaWduZWQgbG9uZyByMywgdW5zaWduZWQgbG9uZyByNCwgdW5z
aWduZWQgbG9uZyByNSwKKwkJCXVuc2lnbmVkIGxvbmcgcjYsIHVuc2lnbmVkIGxvbmcgcjcpCit7
CisJQ1VCT09UX0lOSVQoKTsKKwlmdF9pbml0KF9kdGJfc3RhcnQsIF9kdGJfZW5kIC0gX2R0Yl9z
dGFydCwgMzIpOworCXNlcmlhbF9jb25zb2xlX2luaXQoKTsKKwlwbGF0Zm9ybV9vcHMuZml4dXBz
ID0gcGxhdGZvcm1fZml4dXBzOworfQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2Jvb3QvZHRz
L2FtaWdhb25lLmR0cyBiL2FyY2gvcG93ZXJwYy9ib290L2R0cy9hbWlnYW9uZS5kdHMKbmV3IGZp
bGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uZjkxZDFkZQotLS0gL2Rldi9udWxsCisrKyBi
L2FyY2gvcG93ZXJwYy9ib290L2R0cy9hbWlnYW9uZS5kdHMKQEAgLTAsMCArMSwyMjQgQEAKKy8q
CisgKiBBbWlnYU9uZSBEZXZpY2UgVHJlZSBTb3VyY2UKKyAqCisgKiBDb3B5cmlnaHQgMjAwNyBH
ZXJoYXJkIFBpcmNoZXIgKGdlcmhhcmRfcGlyY2hlckBnbXgubmV0KQorICoKKyAqIFRoaXMgcHJv
Z3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSAgaXQgYW5kL29yIG1v
ZGlmeSBpdAorICogdW5kZXIgIHRoZSB0ZXJtcyBvZiAgdGhlIEdOVSBHZW5lcmFsICBQdWJsaWMg
TGljZW5zZSBhcyBwdWJsaXNoZWQgYnkgdGhlCisgKiBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247
ICBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSAgTGljZW5zZSwgb3IgKGF0IHlvdXIKKyAqIG9wdGlv
bikgYW55IGxhdGVyIHZlcnNpb24uCisgKi8KKworLyB7CisJbW9kZWwgPSAiQW1pZ2FPbmUiOwor
CWNvbXBhdGlibGUgPSAiZXlldGVjaCxhbWlnYW9uZSIsIm1haS1sb2dpYyx0ZXJvbiI7CisJY29o
ZXJlbmN5LW9mZjsKKwkjYWRkcmVzcy1jZWxscyA9IDwxPjsKKwkjc2l6ZS1jZWxscyA9IDwxPjsK
KworCWNwdXMgeworCQkjY3B1cyA9IDwxPjsKKwkJI2FkZHJlc3MtY2VsbHMgPSA8MT47CisJCSNz
aXplLWNlbGxzID0gPDA+OworCisJCWNwdUAwIHsKKwkJCWRldmljZV90eXBlID0gImNwdSI7CisJ
CQlyZWcgPSA8MD47CisJCQlkLWNhY2hlLWxpbmUtc2l6ZSA9IDwyMD47CS8vIDMyIGJ5dGVzCisJ
CQlpLWNhY2hlLWxpbmUtc2l6ZSA9IDwyMD47CS8vIDMyIGJ5dGVzCisJCQlkLWNhY2hlLXNpemUg
PSA8ODAwMD47CQkvLyBMMSwgMzJLCisJCQlpLWNhY2hlLXNpemUgPSA8ODAwMD47CQkvLyBMMSwg
MzJLCisJCQl0aW1lYmFzZS1mcmVxdWVuY3kgPSA8MD47CS8vIDMzLjMgTUh6LCBmcm9tIFUtYm9v
dAorCQkJY2xvY2stZnJlcXVlbmN5ID0gPDA+OwkJLy8gRnJvbSBVLWJvb3QKKwkJCWJ1cy1mcmVx
dWVuY3kgPSA8MD47CQkvLyBGcm9tIFUtYm9vdAorCQkJMzItYml0OworCQl9OworCX07CisKKwlt
ZW1vcnkgeworCQlkZXZpY2VfdHlwZSA9ICJtZW1vcnkiOworCQlyZWcgPSA8MCAwPjsJCQkJLy8g
RnJvbSBVLWJvb3QKKwl9OworCisgIAlwY2lAODAwMDAwMDAgeworCQlkZXZpY2VfdHlwZSA9ICJw
Y2kiOworCQljb21wYXRpYmxlID0gIm1haS1sb2dpYyxhcnRpY2lhLXMiOworCQlidXMtZnJlcXVl
bmN5ID0gPDAxZmNhMDU1PjsJCS8vIDMzLjNNSHoKKwkJYnVzLXJhbmdlID0gPDAgZmY+OworCQly
YW5nZXMgPSA8MDEwMDAwMDAgMCAwMDAwMDAwMCBmZTAwMDAwMCAwIDAwYzAwMDAwCS8vIFBDSSBJ
L08KKwkJCSAgMDIwMDAwMDAgMCA4MDAwMDAwMCA4MDAwMDAwMCAwIDdkMDAwMDAwCS8vIFBDSSBt
ZW1vcnkKKwkJCSAgMDIwMDAwMDAgMCBmZDAwMDAwMCBmZDAwMDAwMCAwIDAxMDAwMDAwPjsJLy8g
UENJIGFsaWFzIG1lbW9yeQorCQk4MjU5LWludGVycnVwdC1hY2tub3dsZWRnZSA9IDxmZWYwMDAw
MD47CisJCS8qIERvIG5vdCBkZWZpbmUgYSBpbnRlcnJ1cHQtcGFyZW50IGhlcmUsIGlmIHRoZXJl
IGlzIG5vIGludGVycnVwdC1tYXAgcHJvcGVydHkuICovCisJCSNhZGRyZXNzLWNlbGxzID0gPDM+
OworCQkjc2l6ZS1jZWxscyA9IDwyPjsKKworCQlob3N0QDAgeworCQkJY29tcGF0aWJsZSA9ICJw
Y2ljbGFzcywwNjAwIjsKKwkJCXZlbmRvci1pZCA9IDwwMDAwMTBjYz47CisJCQlkZXZpY2UtaWQg
PSA8MDAwMDA2NjA+OworCQkJcmV2aXNpb24taWQgPSA8MDAwMDAwMDE+OworCQkJY2xhc3MtY29k
ZSA9IDwwMDA2MDAwMD47CisJCQlzdWJzeXN0ZW0taWQgPSA8MD47CisJCQlzdWJzeXN0ZW0tdmVu
ZG9yLWlkID0gPDA+OworCQkJZGV2c2VsLXNwZWVkID0gPDAwMDAwMDAxPjsKKwkJCTY2bWh6LWNh
cGFibGU7CisJCQltaW4tZ3JhbnQgPSA8MD47CisJCQltYXgtbGF0ZW5jeSA9IDwwPjsKKwkJCS8v
IEFHUCBhcGVydHVyZSBpcyB1bnNldC4KKy8vCQkJcmVnID0gPDQyMDAwMDEwIDAgMDAwMDAwMDAg
MCAwMDQwMDAwMD47CisvLwkJCWFzc2lnbmVkLWFkZHJlc3NlcyA9IDw0MjAwMDAxMCAwIDAwMDAw
MDAwIDAgMDA0MDAwMDA+OworCQl9OworCisJCWlzYUA3IHsKKwkJCWRldmljZV90eXBlID0gImlz
YSI7CisJCQljb21wYXRpYmxlID0gInBjaWNsYXNzLDA2MDEiOworCQkJdmVuZG9yLWlkID0gPDAw
MDAxMTA2PjsKKwkJCWRldmljZS1pZCA9IDwwMDAwMDY4Nj47CisJCQlyZXZpc2lvbi1pZCA9IDww
MDAwMDAxMD47CisJCQljbGFzcy1jb2RlID0gPDAwMDYwMTAwPjsKKwkJCXN1YnN5c3RlbS1pZCA9
IDwwPjsKKwkJCXN1YnN5c3RlbS12ZW5kb3ItaWQgPSA8MD47CisJCQlkZXZzZWwtc3BlZWQgPSA8
MDAwMDAwMDE+OworCQkJbWluLWdyYW50ID0gPDA+OworCQkJbWF4LWxhdGVuY3kgPSA8MD47CisJ
CQkvKiBGaXJzdCA2NGsgZm9yIEkvTyBhdCAweDAgb24gUENJIG1hcHBlZCB0byAweDAgb24gSVNB
LiAqLworCQkJcmFuZ2VzID0gPDAwMDAwMDAxIDAgMDEwMDAwMDAgMCAwMDAwMDAwMCAwMDAxMDAw
MD47CisJCQlpbnRlcnJ1cHQtcGFyZW50ID0gPCZpODI1OT47CisJCQkjaW50ZXJydXB0LWNlbGxz
ID0gPDI+OworCQkJI2FkZHJlc3MtY2VsbHMgPSA8Mj47CisJCQkjc2l6ZS1jZWxscyA9IDwxPjsK
KworCQkJZG1hLWNvbnRyb2xsZXJAMCB7CisJCQkJZGV2aWNlX3R5cGUgPSAiZG1hLWNvbnRyb2xs
ZXIiOworCQkJCWNvbXBhdGlibGUgPSAicG5wUE5QLDIwMCI7CisJCQkJcmVnID0gPDAwMDAwMDAx
IDAwMDAwMDAwIDAwMDAwMDIwCisJCQkJICAgICAgIDAwMDAwMDAxIDAwMDAwMDgwIDAwMDAwMDEw
CisJCQkJICAgICAgIDAwMDAwMDAxIDAwMDAwMGMwIDAwMDAwMDIwPjsKKwkJCQkvKiBDaGFubmVs
IDQgcmVzZXJ2ZXJkLCBjYXNjYWRlIG1vZGUsIDJ4MzJrIHRyYW5zZmVyL2NvdW50ZXIKKwkJCQkg
KiB3aWR0aHMgYW5kIGJ1cyBtYXN0ZXIgY2FwYWJpbGl0eS4gSXMgdGhpcyByZWFsbHkgbmVjZXNz
YXJ5PworCQkJCSAqLworLyoJCQkJZG1hID0gPDQgNCAyMCAyMCAxPjsgKi8KKwkJCX07CisKKwkJ
ICAJaTgyNTk6IGludGVycnVwdC1jb250cm9sbGVyQDIwIHsKKwkJCQlkZXZpY2VfdHlwZSA9ICJp
bnRlcnJ1cHQtY29udHJvbGxlciI7CisJCQkJY29tcGF0aWJsZSA9ICJwbnBQTlAsMDAwIjsKKwkJ
CQlpbnRlcnJ1cHQtY29udHJvbGxlcjsKKwkJCQlyZWcgPSA8MDAwMDAwMDEgMDAwMDAwMjAgMDAw
MDAwMDIKKwkJCQkgICAgICAgMDAwMDAwMDEgMDAwMDAwYTAgMDAwMDAwMDIKKwkJCQkgICAgICAg
MDAwMDAwMDEgMDAwMDA0ZDAgMDAwMDAwMDI+OworCQkJCXJlc2VydmVkLWludGVycnVwdHMgPSA8
Mj47CisJCQkJI2ludGVycnVwdC1jZWxscyA9IDwyPjsKKwkJCX07CisKKwkJCXRpbWVyQDQwIHsK
Ky8qCQkJCWRldmljZV90eXBlID0gInRpbWVyIjsgKi8JCS8vIE5vIGRldmljZSB0eXBlIGJpbmRp
bmcgZm9yIG5vdy4KKwkJCQljb21wYXRpYmxlID0gInBucFBOUCwxMDAiOwkJLy8gQWxzbyBhZGQg
cGNzcGtyIHRvIHBsYXRmb3JtIGRldmljZXMuCisJCQkJcmVnID0gPDAwMDAwMDAxIDAwMDAwMDQw
IDAwMDAwMDIwPjsKKwkJCX07CisKKwkJCTgwNDJANjAgeworCQkJCWRldmljZV90eXBlID0gIjgw
NDIiOworCQkJCXJlZyA9IDwwMDAwMDAwMSAwMDAwMDA2MCAwMDAwMDAwMQorCQkJCSAgICAgICAw
MDAwMDAwMSAwMDAwMDA2NCAwMDAwMDAwMT47CisJCQkJaW50ZXJydXB0cyA9IDwxIDMgYyAzPjsJ
CQkvLyBJUlExLCBJUlExMiAocmlzaW5nIGVkZ2UpCisJCQkJI2FkZHJlc3MtY2VsbHMgPSA8MT47
CisJCQkJI3NpemUtY2VsbHMgPSA8MD47CisKKwkJCQlrZXlib2FyZEAwIHsKKwkJCQkJZGV2aWNl
X3R5cGUgPSAia2V5Ym9hcmQiOworCQkJCQljb21wYXRpYmxlID0gInBucFBOUCwzMDMiOworCQkJ
CQlyZWcgPSA8MD47CisJCQkJfTsKKworCQkJCW1vdXNlQDEgeworCQkJCQlkZXZpY2VfdHlwZSA9
ICJtb3VzZSI7CisJCQkJCWNvbXBhdGlibGUgPSAicG5wUE5QLGYwMyI7CisJCQkJCXJlZyA9IDwx
PjsKKwkJCQl9OworCQkJfTsKKworCQkJcnRjQDcwIHsKKwkJCQlkZXZpY2VfdHlwZSA9ICJydGMi
OworCQkJCWNvbXBhdGlibGUgPSAicG5wUE5QLGIwMCI7CisJCQkJcmVnID0gPDAwMDAwMDAxIDAw
MDAwMDcwIDAwMDAwMDAyPjsKKwkJCQlpbnRlcnJ1cHRzID0gPDggMz47CisJCQl9OworCisJCQlz
ZXJpYWxAMmY4IHsKKwkJCQlkZXZpY2VfdHlwZSA9ICJzZXJpYWwiOworCQkJCWNvbXBhdGlibGUg
PSAicG5wUE5QLDUwMSIsInBucFBOUCw1MDAiOwkvLyAibnMxNjU1MCI7IGFkZCBwcm9wZXJ0eSBj
aGVjayB0byBPRiBzZXJpYWwgY29kZS4KKwkJCQlyZWcgPSA8MDAwMDAwMDEgMDAwMDAyZjggMDAw
MDAwMDg+OworCQkJCWludGVycnVwdHMgPSA8MyAzPjsJCQkvLyBJUlEzIChyaXNpbmcgZWRnZSkK
KwkJCQljbG9jay1mcmVxdWVuY3kgPSA8MDAxQzIwMDA+OwkJLy8gTm90IG5lY2Vzc2FyeT8KKwkJ
CX07CisKKwkJCXNlcmlhbEAzZjggeworCQkJCWRldmljZV90eXBlID0gInNlcmlhbCI7CisJCQkJ
Y29tcGF0aWJsZSA9ICJwbnBQTlAsNTAxIiwicG5wUE5QLDUwMCI7CS8vICJuczE2NTUwIjsgYWRk
IHByb3BlcnR5IGNoZWNrIHRvIE9GIHNlcmlhbCBjb2RlLgorCQkJCXJlZyA9IDwwMDAwMDAwMSAw
MDAwMDNmOCAwMDAwMDAwOD47CisJCQkJaW50ZXJydXB0cyA9IDw0IDM+OwkJCS8vIElSUTQgKHJp
c2luZyBlZGdlKQorCQkJCWNsb2NrLWZyZXF1ZW5jeSA9IDwwMDFDMjAwMD47CQkvLyBOb3QgbmVj
ZXNzYXJ5PworCQkJfTsKKworCQkJcGFyYWxsZWxAMzc4IHsKKwkJCQlkZXZpY2VfdHlwZSA9ICJw
YXJhbGxlbCI7CisJCQkJY29tcGF0aWJsZSA9ICJwbnBQTlAsNDAwIjsgCQkvLyAicG5wUE5QLDQw
MSIJLy8gTm8gRUNQIHN1cHBvcnQgZm9yIG5vdy4KKwkJCQlyZWcgPSA8MDAwMDAwMDEgMDAwMDAz
NzggMDAwMDAwMDMKKwkJCQkgICAgICAgMDAwMDAwMDEgMDAwMDA3NzggMDAwMDAwMDM+OworLyoJ
CQkJaW50ZXJydXB0cyA9IDw3IDM+OyAqLworLyoJCQkJZG1hID0gPDMgMCAwIDA+OyAqLwkJCS8v
IFBhcmFsbGVsIHBvcnQgRE1BIG1vZGU/CisJCQl9OworCisJCQlmZGNAM2YwIHsKKwkJCQlkZXZp
Y2VfdHlwZSA9ICJmZGMiOworCQkJCWNvbXBhdGlibGUgPSAicG5wUE5QLDcwMCI7CisJCQkJcmVn
ID0gPDAwMDAwMDAxIDAwMDAwM2YwIDAwMDAwMDA4PjsKKwkJCQlpbnRlcnJ1cHRzID0gPDYgMz47
CQkJLy8gSVJRNiAocmlzaW5nIGVkZ2UpCisvKgkJCQlkbWEgPSA8ID47ICovCQkJCS8vIEZsb3Bw
eSBETUEgbW9kZT8KKwkJCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsKKwkJCQkjc2l6ZS1jZWxscyA9
IDwwPjsKKworCQkJCWRpc2tAMCB7CisJCQkJCWRldmljZV90eXBlID0gImJsb2NrIjsKKwkJCQkJ
cmVnID0gPDA+OworCQkJCX07CisJCQl9OworCQl9OworCisJCWlkZUA3LDEgeworCQkJY29tcGF0
aWJsZSA9ICJwY2ljbGFzcywwMTAxOGIiOworCQkJdmVuZG9yLWlkID0gPDAwMDAxMTA2PjsKKwkJ
CWRldmljZS1pZCA9IDwwMDAwMDU3MT47CisJCQlyZXZpc2lvbi1pZCA9IDwwMDAwMDAwNj47CisJ
CQkvLyBDbGFzcyBjb2RlIHdpdGggUENJIElERSBwcm9ncmFtbWluZyBpbnRlcmZhY2UgaW5kaWNh
dG9yLgorCQkJY2xhc3MtY29kZSA9IDwwMDAxMDE4Yj47CisJCQlzdWJzeXN0ZW0taWQgPSA8MD47
CisJCQlzdWJzeXN0ZW0tdmVuZG9yLWlkID0gPDA+OworCQkJZGV2c2VsLXNwZWVkID0gPDAwMDAw
MDAxPjsKKwkJCW1pbi1ncmFudCA9IDwwPjsKKwkJCW1heC1sYXRlbmN5ID0gPDA+OworCQkJZmFz
dC1iYWNrLXRvLWJhY2s7CisJCQkvLyBBc3N1bWUgYmFzZSBhZGRyZXNzZXMgYXJlIHJlbG9jYXRl
YWJsZSwgZXZlbiBpZgorCQkJLy8gY29udHJvbGxlciBvcGVyYXRlcyBpbiBjb21wYXRpYmlsaXR5
IG1vZGUuCisJCQlyZWcgPSA8MjEwMDM5MTAgMCAwMDAwMDAwMCAwIDAwMDAwMDAwCisJCQkgICAg
ICAgMjEwMDM5MTQgMCAwMDAwMDAwMCAwIDAwMDAwMDAwCisJCQkgICAgICAgMjEwMDM5MTggMCAw
MDAwMDAwMCAwIDAwMDAwMDAwCisJCQkgICAgICAgMjEwMDM5MWMgMCAwMDAwMDAwMCAwIDAwMDAw
MDAwCisJCQkgICAgICAgMjEwMDM5MjAgMCAwMDAwMDAwMCAwIDAwMDAwMDAwPjsKKwkJCWFzc2ln
bmVkLWFkZHJlc3NlcyA9IDwwMTAwMzkxMCAwIDAwMDAwMWYwIDAgMDAwMDAwMDgKKwkJCQkJICAg
ICAgMDEwMDM5MTQgMCAwMDAwMDNmNCAwIDAwMDAwMDA0CisJCQkJCSAgICAgIDAxMDAzOTE4IDAg
MDAwMDAxNzAgMCAwMDAwMDAwOAorCQkJCQkgICAgICAwMTAwMzkxYyAwIDAwMDAwMzc0IDAgMDAw
MDAwMDQKKwkJCQkJICAgICAgMDEwMDM5MjAgMCAwMDAwY2MwMCAwIDAwMDAwMDEwPjsKKy8qCQkJ
aW50ZXJydXB0LXBhcmVudCA9IDwmaTgyNTk+OworCQkJaW50ZXJydXB0cyA9IDxlIDMgZiAzPjsK
KwkJCSNpbnRlcnJ1cHQtY2VsbHMgPSA8Mj47ICovCisJCX07CisJfTsKKworCWNob3NlbiB7CisJ
CWxpbnV4LHN0ZG91dC1wYXRoID0gIi9wY2lAODAwMDAwMDAvaXNhQDcvc2VyaWFsQDJmOCI7CisJ
fTsKK307CmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvYm9vdC96SW1hZ2UubGRzLlMgYi9hcmNo
L3Bvd2VycGMvYm9vdC96SW1hZ2UubGRzLlMKaW5kZXggZjZlMzgwZi4uZGQwZmRlOCAxMDA2NDQK
LS0tIGEvYXJjaC9wb3dlcnBjL2Jvb3QvekltYWdlLmxkcy5TCisrKyBiL2FyY2gvcG93ZXJwYy9i
b290L3pJbWFnZS5sZHMuUwpAQCAtMyw3ICszLDcgQEAgRU5UUlkoX3ppbWFnZV9zdGFydCkKIEVY
VEVSTihfemltYWdlX3N0YXJ0KQogU0VDVElPTlMKIHsKLSAgLiA9ICg0KjEwMjQqMTAyNCk7Cisg
IC4gPSAoOCoxMDI0KjEwMjQpOwogICBfc3RhcnQgPSAuOwogICAudGV4dCAgICAgIDoKICAgewpk
aWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9wY2lfMzIuYyBiL2FyY2gvcG93ZXJwYy9r
ZXJuZWwvcGNpXzMyLmMKaW5kZXggMGUyYmVlNC4uNWI1ZWQ3NiAxMDA2NDQKLS0tIGEvYXJjaC9w
b3dlcnBjL2tlcm5lbC9wY2lfMzIuYworKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3BjaV8zMi5j
CkBAIC01ODUsNyArNTg1LDkgQEAgcGNpYmlvc19hc3NpZ25fcmVzb3VyY2VzKHZvaWQpCiAKIAkJ
CQlyLT5mbGFncyAmPSB+SU9SRVNPVVJDRV9VTlNFVDsKIAkJCQlyYyA9IHBjaV9hc3NpZ25fcmVz
b3VyY2UoZGV2LCBpZHgpOworI2lmbmRlZiBDT05GSUdfQU1JR0FPTkUKIAkJCQlCVUdfT04ocmMp
OworI2VuZGlmCiAJCQl9CiAJCX0KIApkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jt
cy9LY29uZmlnIGIvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9LY29uZmlnCmluZGV4IGVhMjJjYWQu
LjE4MDI2YWQgMTAwNjQ0Ci0tLSBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvS2NvbmZpZworKysg
Yi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL0tjb25maWcKQEAgLTU2LDYgKzU2LDcgQEAgc291cmNl
ICJhcmNoL3Bvd2VycGMvcGxhdGZvcm1zLzg2eHgvS2NvbmZpZyIKIHNvdXJjZSAiYXJjaC9wb3dl
cnBjL3BsYXRmb3Jtcy9lbWJlZGRlZDZ4eC9LY29uZmlnIgogc291cmNlICJhcmNoL3Bvd2VycGMv
cGxhdGZvcm1zLzQ0eC9LY29uZmlnIgogc291cmNlICJhcmNoL3Bvd2VycGMvcGxhdGZvcm1zLzQw
eC9LY29uZmlnIgorc291cmNlICJhcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2FtaWdhb25lL0tjb25m
aWciCiAKIGNvbmZpZyBQUENfTkFUSVZFCiAJYm9vbApkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBj
L3BsYXRmb3Jtcy9NYWtlZmlsZSBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvTWFrZWZpbGUKaW5k
ZXggNmQ5MDc5ZC4uNjQ2MGVmYSAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9N
YWtlZmlsZQorKysgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL01ha2VmaWxlCkBAIC0yNSwzICsy
NSw0IEBAIG9iai0kKENPTkZJR19QUENfQ0VMTCkJCSs9IGNlbGwvCiBvYmotJChDT05GSUdfUFBD
X1BTMykJCSs9IHBzMy8KIG9iai0kKENPTkZJR19QUENfQ0VMTEVCKQkrPSBjZWxsZWIvCiBvYmot
JChDT05GSUdfRU1CRURERUQ2eHgpCSs9IGVtYmVkZGVkNnh4Lworb2JqLSQoQ09ORklHX0FNSUdB
T05FKQkJKz0gYW1pZ2FvbmUvCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2Ft
aWdhb25lL0tjb25maWcgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2FtaWdhb25lL0tjb25maWcK
bmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uOGU2MmQxMgotLS0gL2Rldi9udWxs
CisrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvYW1pZ2FvbmUvS2NvbmZpZwpAQCAtMCwwICsx
LDE3IEBACitjb25maWcgQU1JR0FPTkUKKwlib29sICJFeWV0ZWNoIEFtaWdhT25lL01BSSBUZXJv
biIKKwlkZXBlbmRzIG9uIFBQQ19NVUxUSVBMQVRGT1JNICYmIFBQQzMyCisJc2VsZWN0IFBQQ19J
ODI1OQorCXNlbGVjdCBQUENfSU5ESVJFQ1RfUENJCisJc2VsZWN0IFBQQ19VREJHXzE2NTUwCisJ
c2VsZWN0IE5PVF9DT0hFUkVOVF9DQUNIRQorCXNlbGVjdCBDSEVDS19DQUNIRV9DT0hFUkVOQ1kK
KwlzZWxlY3QgREVGQVVMVF9VSU1BR0UKKwlzZWxlY3QgV0FOVF9ERVZJQ0VfVFJFRQorCWhlbHAK
KwlTZWxlY3QgQW1pZ2FPbmUgZm9yIHRoZSBmb2xsb3dpbmcgbWFjaGluZXM6CisJLSBBbWlnYU9u
ZSBTRS9UZXJvbiBDWCAoRzMgb25seSkKKwktIEFtaWdhT25lIFhFL1Rlcm9uIFBYCisJLSB1QTEv
VGVyb24gbWluaQorCSAgTW9yZSBpbmZvcm1hdGlvbiBpcyBhdmFpbGFibGUgYXQ6CisJICA8aHR0
cDovL2FtaWdhb25lLWxpbnV4LnNvdXJjZWZvcmdlLm5ldC8+LgpkaWZmIC0tZ2l0IGEvYXJjaC9w
b3dlcnBjL3BsYXRmb3Jtcy9hbWlnYW9uZS9NYWtlZmlsZSBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9y
bXMvYW1pZ2FvbmUvTWFrZWZpbGUKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4u
NWQ2NmY2NgotLS0gL2Rldi9udWxsCisrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvYW1pZ2Fv
bmUvTWFrZWZpbGUKQEAgLTAsMCArMSwzIEBACitvYmoteQkJCQkrPSBzZXR1cC5vCitvYmotJChD
T05GSUdfUENJKQkJKz0gcGNpLm8KKyNvYmotJChDT05GSUdfTlZSQU0pCQkrPSBudnJhbS5vCmRp
ZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2FtaWdhb25lL3BjaS5jIGIvYXJjaC9w
b3dlcnBjL3BsYXRmb3Jtcy9hbWlnYW9uZS9wY2kuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRl
eCAwMDAwMDAwLi4yMWE1NjM4Ci0tLSAvZGV2L251bGwKKysrIGIvYXJjaC9wb3dlcnBjL3BsYXRm
b3Jtcy9hbWlnYW9uZS9wY2kuYwpAQCAtMCwwICsxLDcxIEBACisvKgorICogQW1pZ2FPbmUgcGxh
dGZvcm0gUENJIHNldHVwCisgKgorICogQ29weXJpZ2h0IDIwMDcgR2VyaGFyZCBQaXJjaGVyIChn
ZXJoYXJkX3BpcmNoZXJAZ214Lm5ldCkKKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0
d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgIGl0IGFuZC9vciBtb2RpZnkgaXQKKyAqIHVuZGVy
ICB0aGUgdGVybXMgb2YgIHRoZSBHTlUgR2VuZXJhbCAgUHVibGljIExpY2Vuc2UgYXMgcHVibGlz
aGVkIGJ5IHRoZQorICogRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyAgZWl0aGVyIHZlcnNpb24g
MiBvZiB0aGUgIExpY2Vuc2UsIG9yIChhdCB5b3VyCisgKiBvcHRpb24pIGFueSBsYXRlciB2ZXJz
aW9uLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNsdWRlIDxsaW51eC9w
Y2kuaD4KKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgorI2luY2x1ZGUgPGxpbnV4L3N0cmluZy5o
PgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKworI2luY2x1ZGUgPGFzbS9pby5oPgorI2luY2x1
ZGUgPGFzbS9wZ3RhYmxlLmg+CisjaW5jbHVkZSA8YXNtL2lycS5oPgorI2luY2x1ZGUgPGFzbS9t
YWNoZGVwLmg+CisjaW5jbHVkZSA8YXNtL3NlY3Rpb25zLmg+CisjaW5jbHVkZSA8YXNtL3BjaS1i
cmlkZ2UuaD4KKwordm9pZCBfX2luaXQKK2FtaWdhb25lX2ZpbmRfYnJpZGdlcyh2b2lkKQorewor
CXN0cnVjdCBkZXZpY2Vfbm9kZSAqZGV2OworCWNvbnN0IGludCAqYnVzX3JhbmdlOworCWludCBs
ZW4sIGluZGV4ID0gLTE7CisJc3RydWN0IHBjaV9jb250cm9sbGVyICpob3NlOworCXN0cnVjdCBk
ZXZpY2Vfbm9kZSAqcm9vdCA9IG9mX2ZpbmRfbm9kZV9ieV9wYXRoKCIvIik7CisKKwlmb3IgKGRl
diA9IHJvb3QtPmNoaWxkOyBkZXYgIT0gTlVMTDsgZGV2ID0gZGV2LT5zaWJsaW5nKSB7CisJCWlm
IChkZXYtPnR5cGUgPT0gTlVMTCB8fCBzdHJjbXAoZGV2LT50eXBlLCAicGNpIikgIT0gMCkKKwkJ
CWNvbnRpbnVlOworCQkrK2luZGV4OworCisJCWJ1c19yYW5nZSA9IG9mX2dldF9wcm9wZXJ0eShk
ZXYsICJidXMtcmFuZ2UiLCAmbGVuKTsKKwkJaWYgKGJ1c19yYW5nZSA9PSBOVUxMIHx8IGxlbiA8
IDIgKiBzaXplb2YoaW50KSkgeworCQkJcHJpbnRrKEtFUk5fV0FSTklORyAiQ2FuJ3QgZ2V0IGJ1
cy1yYW5nZSBmb3IgJXNcbiIsCisJCQkJZGV2LT5mdWxsX25hbWUpOworCQkJY29udGludWU7CisJ
CX0KKworLyoJCWlmIChidXNfcmFuZ2VbMV0gPT0gYnVzX3JhbmdlWzBdKQorCQkJcHJpbnRrKEtF
Uk5fSU5GTyAiUENJIGJ1cyAlZCIsIGJ1c19yYW5nZVswXSk7CisJCWVsc2UKKwkJCXByaW50ayhL
RVJOX0lORk8gIlBDSSBidXNlcyAlZC4uJWQiLAorCQkJICAgICAgIGJ1c19yYW5nZVswXSwgYnVz
X3JhbmdlWzFdKTsKKwkJcHJpbnRrKCIgY29udHJvbGxlZCBieSAlcyIsIGRldi0+ZnVsbF9uYW1l
KTsgKi8KKworCQlob3NlID0gcGNpYmlvc19hbGxvY19jb250cm9sbGVyKGRldik7CisJCWlmICgh
aG9zZSkgeworCQkJcHJpbnRrKCJDYW4ndCBhbGxvY2F0ZSBQQ0kgY29udHJvbGxlciBzdHJ1Y3R1
cmUgZm9yICVzXG4iLAorCQkJCWRldi0+ZnVsbF9uYW1lKTsKKwkJCWNvbnRpbnVlOworCQl9CisJ
CWhvc2UtPmFyY2hfZGF0YSA9IGRldjsKKwkJaG9zZS0+Zmlyc3RfYnVzbm8gPSBidXNfcmFuZ2Vb
MF07CisJCWhvc2UtPmxhc3RfYnVzbm8gPSBidXNfcmFuZ2VbMV07CisKKwkJc2V0dXBfaW5kaXJl
Y3RfcGNpKGhvc2UsIDB4ZmVjMDBjZjgsIDB4ZmVlMDBjZmMsIDApOworCisJCS8qIEludGVycHJl
dCB0aGUgInJhbmdlcyIgcHJvcGVydHkgKi8KKwkJLyogVGhpcyBhbHNvIG1hcHMgdGhlIEkvTyBy
ZWdpb24gYW5kIHNldHMgaXNhX2lvL21lbV9iYXNlLiAqLworCQlwY2lfcHJvY2Vzc19icmlkZ2Vf
T0ZfcmFuZ2VzKGhvc2UsIGRldiwgaW5kZXggPT0gMCk7CisJfQorCisJb2Zfbm9kZV9wdXQocm9v
dCk7Cit9CmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2FtaWdhb25lL3NldHVw
LmMgYi9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2FtaWdhb25lL3NldHVwLmMKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uOGVlZWY2OQotLS0gL2Rldi9udWxsCisrKyBiL2FyY2gv
cG93ZXJwYy9wbGF0Zm9ybXMvYW1pZ2FvbmUvc2V0dXAuYwpAQCAtMCwwICsxLDI0MiBAQAorLyoK
KyAqIEFtaWdhT25lIHBsYXRmb3JtIHNldHVwCisgKgorICogQ29weXJpZ2h0IDIwMDcgR2VyaGFy
ZCBQaXJjaGVyIChnZXJoYXJkX3BpcmNoZXJAZ214Lm5ldCkKKyAqCisgKiAgIEJhc2VkIG9uIG9y
aWdpbmFsIGFtaWdhb25lX3NldHVwLmMgc291cmNlIGNvZGUKKyAqIENvcHlyaWdodCAyMDAzIGJ5
IEhhbnMtSsO2cmcgYW5kIFRob21hcyBGcmllZGVuCisgKiAgIGFuZCBjaHJwL3NldHVwLmMKKyAq
IENvcHlyaWdodCAxOTk1IGJ5IExpbnVzIFRvcnZhbGRzCisgKgorICogVGhpcyBwcm9ncmFtIGlz
IGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlICBpdCBhbmQvb3IgbW9kaWZ5IGl0
CisgKiB1bmRlciAgdGhlIHRlcm1zIG9mICB0aGUgR05VIEdlbmVyYWwgIFB1YmxpYyBMaWNlbnNl
IGFzIHB1Ymxpc2hlZCBieSB0aGUKKyAqIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgIGVpdGhl
ciB2ZXJzaW9uIDIgb2YgdGhlICBMaWNlbnNlLCBvciAoYXQgeW91cgorICogb3B0aW9uKSBhbnkg
bGF0ZXIgdmVyc2lvbi4KKyAqLworCisjaW5jbHVkZSA8bGludXgvZXJybm8uaD4KKyNpbmNsdWRl
IDxsaW51eC9zY2hlZC5oPgorI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxp
bnV4L21tLmg+CisjaW5jbHVkZSA8bGludXgvc3RkZGVmLmg+CisjaW5jbHVkZSA8bGludXgvdW5p
c3RkLmg+CisjaW5jbHVkZSA8bGludXgvcHRyYWNlLmg+CisjaW5jbHVkZSA8bGludXgvc2xhYi5o
PgorI2luY2x1ZGUgPGxpbnV4L3VzZXIuaD4KKyNpbmNsdWRlIDxsaW51eC90dHkuaD4KKyNpbmNs
dWRlIDxsaW51eC9tYWpvci5oPgorI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPgorI2luY2x1
ZGUgPGxpbnV4L3JlYm9vdC5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxs
aW51eC9pZGUuaD4KKyNpbmNsdWRlIDxsaW51eC9wY2kuaD4KKyNpbmNsdWRlIDxsaW51eC91dHNy
ZWxlYXNlLmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVkZSA8bGludXgvZGVs
YXkuaD4KKyNpbmNsdWRlIDxsaW51eC9jb25zb2xlLmg+CisjaW5jbHVkZSA8bGludXgvc2VxX2Zp
bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9yb290X2Rldi5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXRy
ZC5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUgPGxpbnV4L3RpbWVyLmg+
CisKKyNpbmNsdWRlIDxhc20vY3B1dGFibGUuaD4KKyNpbmNsdWRlIDxhc20vaW8uaD4KKyNpbmNs
dWRlIDxhc20vcGd0YWJsZS5oPgorI2luY2x1ZGUgPGFzbS9wY2ktYnJpZGdlLmg+CisjaW5jbHVk
ZSA8YXNtL2RtYS5oPgorI2luY2x1ZGUgPGFzbS9tYWNoZGVwLmg+CisjaW5jbHVkZSA8YXNtL2ly
cS5oPgorI2luY2x1ZGUgPGFzbS9zZWN0aW9ucy5oPgorI2luY2x1ZGUgPGFzbS90aW1lLmg+Cisj
aW5jbHVkZSA8YXNtL2k4MjU5Lmg+CisjaW5jbHVkZSA8YXNtL3N5c3RlbS5oPgorI2luY2x1ZGUg
PGFzbS91ZGJnLmg+CisjaW5jbHVkZSA8YXNtL3ZnYS5oPgorCitleHRlcm4gdm9pZCBhbWlnYW9u
ZV9maW5kX2JyaWRnZXModm9pZCk7CisKK3ZvaWQgYW1pZ2FvbmVfc2V0X2wyY3Iodm9pZCkKK3sK
KwkvKiBUaGlzIGRpc2FibGVzIHRoZSBMMiBoYXJkd2FyZSBwcmVmZXRjaC4gSXQgaXMgbm9ybWFs
bHkgZGlzYWJsZWQgYW5kCisJICogZW5hYmxlZCBhZ2FpbiB3aXRoaW4gX3NldF9MMkNSKCksIGJ1
dCB0aGUgTDIgcHJlZmV0Y2ggZW5hYmxlIGlzIG5vdAorCSAqIGNvbXBpbGVkIGluIGZvciB0aGUg
QW1pZ2FPbmUuCisJICovCisJX3NldF9MMkNSKF9nZXRfTDJDUigpKTsKKworCWlmKCgoX2dldF9M
MkNSKCkgJiBMMkNSX0wyRSkgPT0gMCkgJiYgKHN0cnN0cihjbWRfbGluZSwgImwyY3I9IikgPT0g
TlVMTCkpCisJeworCQlwcmludGsoIkFtaWdhT25lIGwyY3IgOiBMMiBjYWNoZSB3YXMgbm90IGFj
dGl2ZSwgYWN0aXZhdGluZy5cbiIpOworCQlfc2V0X0wyQ1IoMCk7CisJCV9zZXRfTDJDUihMMkNS
X0wyRSB8IEwyQ1JfTDJQRSk7CisJfQorfQorCit2b2lkIGFtaWdhb25lX3Nob3dfY3B1aW5mbyhz
dHJ1Y3Qgc2VxX2ZpbGUgKm0pCit7CisJc3RydWN0IGRldmljZV9ub2RlICpyb290OworCWNvbnN0
IGNoYXIgKm1vZGVsID0gIiI7CisKKwlyb290ID0gb2ZfZmluZF9ub2RlX2J5X3BhdGgoIi8iKTsK
KwlpZiAocm9vdCkKKwkJbW9kZWwgPSBvZl9nZXRfcHJvcGVydHkocm9vdCwgIm1vZGVsIiwgTlVM
TCk7CisJc2VxX3ByaW50ZihtLCAibWFjaGluZVx0XHQ6ICVzXG4iLCBtb2RlbCk7CisKKwlvZl9u
b2RlX3B1dChyb290KTsKKworCXNlcV9wcmludGYobSwgImwyY3JcdFx0OiAweCUwOGxYXG4iLCBf
Z2V0X0wyQ1IoKSk7CisJc2VxX3ByaW50ZihtLCAibXNzY3IwXHRcdDogMHglMDhsWFxuIiwgbWZz
cHIoU1BSTl9NU1NDUjApKTsKKworCXJldHVybjsKK30KKwordm9pZCBfX2luaXQgYW1pZ2FvbmVf
c2V0dXBfYXJjaCh2b2lkKQoreworCS8qIGluaXQgdG8gc29tZSB+c2FuZSB2YWx1ZSB1bnRpbCBj
YWxpYnJhdGVfZGVsYXkoKSBydW5zICovCisJbG9vcHNfcGVyX2ppZmZ5ID0gNTAwMDAwMDAvSFo7
CisKKwkvKiBFbmFibGUgdGhlIEwyIGNhY2hlLiAqLworCWFtaWdhb25lX3NldF9sMmNyKCk7CisK
KwkvKiBMb29rdXAgUENJIGhvc3QgYnJpZGdlcyAqLworCS8qIHNldHVwIFBDSSBob3N0IGJyaWRn
ZSAqLworCisjaWZkZWYgQ09ORklHX1BDSV9IT1NUX0RSSVZFUgorCWZvciAobnAgPSBOVUxMOyAo
bnAgPSBvZl9maW5kX25vZGVfYnlfdHlwZShucCwgInBjaSIpKSAhPSBOVUxMOykKKwkJYXJ0aWNp
YXNfc2V0dXBfcGNpKG5wKTsKKyNlbHNlCisJYW1pZ2FvbmVfZmluZF9icmlkZ2VzKCk7CisjZW5k
aWYKKworCS8qIFVuY29tbWVudCwgd2hlbiBVLWJvb3Qgd2FzIHVwZGF0ZWQuICovCisvLwlwY2lf
Y3JlYXRlX09GX2J1c19tYXAoKTsKKworCS8qIHZnYWNvbi5jIG5lZWRzIHRvIGtub3cgd2hlcmUg
VkdBIG1lbW9yeSBpcyBtYXBwZWQuICovCisvLwl2Z2Fjb25fcmVtYXBfYmFzZSA9ICh1bnNpZ25l
ZCBsb25nKSBpb3JlbWFwKDB4ZmQwMDAwMDAsIDB4MDAxMDAwMDApOworLy8JY29uc3dpdGNocCA9
ICZ2Z2FfY29uOworCisJaWYgKHBwY19tZC5wcm9ncmVzcykKKwkJcHBjX21kLnByb2dyZXNzKCJM
aW51eC9QUEMgIlVUU19SRUxFQVNFIlxuIiwgMHgwKTsKK30KKwordm9pZCBfX2luaXQgYW1pZ2Fv
bmVfaW5pdF9JUlEodm9pZCkKK3sKKwlzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wLCAqcGljID0gTlVM
TDsKKwl1bnNpZ25lZCBsb25nIGFtaWdhb25lX2ludF9hY2sgPSAwOworCisJLyogU2VhcmNoIGZv
ciBJU0EgaW50ZXJydXB0IGNvbnRyb2xsZXIuICovCisJZm9yX2VhY2hfbm9kZV9ieV90eXBlKG5w
LCAiaW50ZXJydXB0LWNvbnRyb2xsZXIiKQorCQlpZiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUo
bnAsICJwbnBQTlAsMDAwIikpIHsKKwkJCXBpYyA9IG5wOworCQkJYnJlYWs7CisJCX0KKworCUJV
R19PTihwaWMgPT0gTlVMTCk7CisKKwkvKiBMb29rIGZvciBpbnRlcnJ1cHQgYWNrbm93bGVkZ2Ug
YWRkcmVzcyBpbiB0aGUgUENJIHJvb3Qgbm9kZS4gKi8KKwlmb3JfZWFjaF9ub2RlX2J5X25hbWUo
bnAsICJwY2kiKSB7CisJCWNvbnN0IHVuc2lnbmVkIGludCAqYWRkcnAgPSBvZl9nZXRfcHJvcGVy
dHkobnAsCisJCQkiODI1OS1pbnRlcnJ1cHQtYWNrbm93bGVkZ2UiLCBOVUxMKTsKKworCQlpZiAo
YWRkcnAgPT0gTlVMTCkKKwkJCWNvbnRpbnVlOworCQlhbWlnYW9uZV9pbnRfYWNrID0gYWRkcnBb
b2Zfbl9hZGRyX2NlbGxzKG5wKS0xXTsKKwkJYnJlYWs7CisJfQorCW9mX25vZGVfcHV0KG5wKTsK
KworCWlmIChucCA9PSBOVUxMKQorCQlwcmludGsoS0VSTl9XQVJOSU5HICJDYW5ub3QgZmluZCBQ
Q0kgaW50ZXJydXB0IGFja25vd2xlZGdlIgorCQkgICAgICAgIiBhZGRyZXNzLCBwb2xsaW5nXG4i
KTsKKworCWk4MjU5X2luaXQocGljLCBhbWlnYW9uZV9pbnRfYWNrKTsKKwlwcGNfbWQuZ2V0X2ly
cSA9IGk4MjU5X2lycTsKKwlpcnFfc2V0X2RlZmF1bHRfaG9zdChpODI1OV9nZXRfaG9zdCgpKTsK
K30KKwordm9pZCBfX2luaXQgYW1pZ2FvbmVfaW5pdCh2b2lkKQoreworI2lmZGVmIENPTkZJR19O
VlJBTQorLy8JYW1pZ2FvbmVfbnZyYW1faW5pdCgpOworI2VuZGlmCisKKwlyZXF1ZXN0X3JlZ2lv
bigweDIwLDB4MjAsInBpYzEiKTsKKwlyZXF1ZXN0X3JlZ2lvbigweGEwLDB4MjAsInBpYzIiKTsK
KwlyZXF1ZXN0X3JlZ2lvbigweDAwLDB4MjAsImRtYTEiKTsKKwlyZXF1ZXN0X3JlZ2lvbigweDQw
LDB4MjAsInRpbWVyIik7CisJcmVxdWVzdF9yZWdpb24oMHg4MCwweDEwLCJkbWEgcGFnZSByZWci
KTsKKwlyZXF1ZXN0X3JlZ2lvbigweGMwLDB4MjAsImRtYTIiKTsKK30KKworLyogQ29waWVkIGZy
b20gVS1Cb290LiAqLworc3RhdGljIGlubGluZSB2b2lkIHNvZnRfcmVzdGFydCh1bnNpZ25lZCBs
b25nIGFkZHIpCit7CisJLyogU1JSMCBoYXMgc3lzdGVtIHJlc2V0IHZlY3RvciwgU1JSMSBoYXMg
ZGVmYXVsdCBNU1IgdmFsdWUuCisJICogcmZpIHJlc3RvcmVzIE1TUiBmcm9tIFNSUjEgYW5kIHNl
dHMgdGhlIFBDIHRvIHRoZSBTUlIwIHZhbHVlLgorCSAqLworCV9fYXNtX18gX192b2xhdGlsZV9f
ICgibXRzcHIJMjYsICUwIgkJOjogInIiIChhZGRyKSk7CisJX19hc21fXyBfX3ZvbGF0aWxlX18g
KCJsaQk0LCAoMSA8PCA2KSIJOjo6ICJyNCIpOworCV9fYXNtX18gX192b2xhdGlsZV9fICgibXRz
cHIJMjcsIDQiKTsKKwlfX2FzbV9fIF9fdm9sYXRpbGVfXyAoInJmaSIpOworCisJLyogTm90IHJl
YWNoZWQuICovCisJd2hpbGUoMSk7Cit9CisKK3ZvaWQgYW1pZ2FvbmVfcmVzdGFydChjaGFyICpj
bWQpCit7CisgICAgCXVuc2lnbmVkIGxvbmcgYWRkcjsKKworCWxvY2FsX2lycV9kaXNhYmxlKCk7
CisKKwkvKiBGbHVzaCBhbmQgZGlzYWJsZSBJL0QgY2FjaGUuICovCisJX19hc21fXyBfX3ZvbGF0
aWxlX18gKCJtZnNwcgkzLCAxMDA4Igk6OjogInIzIik7CisJX19hc21fXyBfX3ZvbGF0aWxlX18g
KCJvcmkJNSwgNSwgMHhjYzAwIgk6OjogInI1Iik7CisJX19hc21fXyBfX3ZvbGF0aWxlX18gKCJv
cmkJNCwgMywgMHhjMDAiCTo6OiAicjQiKTsKKwlfX2FzbV9fIF9fdm9sYXRpbGVfXyAoImFuZGMJ
NSwgMywgNSIJOjo6ICJyNSIpOworCV9fYXNtX18gX192b2xhdGlsZV9fICgic3luYyIpOworCV9f
YXNtX18gX192b2xhdGlsZV9fICgibXRzcHIJMTAwOCwgNCIpOworCV9fYXNtX18gX192b2xhdGls
ZV9fICgiaXN5bmMiKTsKKwlfX2FzbV9fIF9fdm9sYXRpbGVfXyAoInN5bmMiKTsKKwlfX2FzbV9f
IF9fdm9sYXRpbGVfXyAoIm10c3ByCTEwMDgsIDUiKTsKKwlfX2FzbV9fIF9fdm9sYXRpbGVfXyAo
ImlzeW5jIik7CisJX19hc21fXyBfX3ZvbGF0aWxlX18gKCJzeW5jIik7CisKKwlhZGRyID0gMHhm
ZmYwMDEwMDsKKwlzb2Z0X3Jlc3RhcnQoYWRkcik7CisJd2hpbGUoMSk7Cit9CisKK3N0YXRpYyBp
bnQgX19pbml0IGFtaWdhb25lX3Byb2JlKHZvaWQpCit7CisJdW5zaWduZWQgbG9uZyByb290ID0g
b2ZfZ2V0X2ZsYXRfZHRfcm9vdCgpOworCisgCWlmIChvZl9mbGF0X2R0X2lzX2NvbXBhdGlibGUo
cm9vdCwgImV5ZXRlY2gsYW1pZ2FvbmUiKSkgeworCSAJLyogQ29oZXJlbnQgbWVtb3J5IGFjY2Vz
cyBjYXVzZSBjb21wbGV0ZSBzeXN0ZW0gbG9ja3VwISBUaHVzCisJCSAqIHJlbW92ZSBpdCBpbiBh
bnkgY2FzZSwgZXZlbiBpZiB0aGUgQ1BVIG5lZWRzIGl0LiBXZSdsbAorCQkgKiBkaXNhYmxlIHRo
ZSBMMiBjYWNoZSBwcmVmZXRjaCBsYXRlciBvbi4KKwkJICovCisJIAljdXJfY3B1X3NwZWMtPmNw
dV9mZWF0dXJlcyAmPSB+Q1BVX0ZUUl9ORUVEX0NPSEVSRU5UOworCisJCUlTQV9ETUFfVEhSRVNI
T0xEID0gMHgwMEZGRkZGRjsKKwkJRE1BX01PREVfUkVBRCA9IDB4NDQ7CisJCURNQV9NT0RFX1dS
SVRFID0gMHg0ODsKKworCQlyZXR1cm4gMTsKKwl9CisKKwlyZXR1cm4gMDsKK30KKworZGVmaW5l
X21hY2hpbmUoYW1pZ2FvbmUpIHsKKwkubmFtZQkJCT0gIkFtaWdhT25lIiwKKwkucHJvYmUJCQk9
IGFtaWdhb25lX3Byb2JlLAorCS5zZXR1cF9hcmNoCQk9IGFtaWdhb25lX3NldHVwX2FyY2gsCisJ
LmluaXQJCQk9IGFtaWdhb25lX2luaXQsCisJLnNob3dfY3B1aW5mbwkJPSBhbWlnYW9uZV9zaG93
X2NwdWluZm8sCisJLmluaXRfSVJRCQk9IGFtaWdhb25lX2luaXRfSVJRLAorCS5yZXN0YXJ0CQk9
IGFtaWdhb25lX3Jlc3RhcnQsCisJLmNhbGlicmF0ZV9kZWNyCQk9IGdlbmVyaWNfY2FsaWJyYXRl
X2RlY3IsCisJLnByb2dyZXNzCQk9IHVkYmdfcHJvZ3Jlc3MsCisJLnBoeXNfbWVtX2FjY2Vzc19w
cm90CT0gcGNpX3BoeXNfbWVtX2FjY2Vzc19wcm90LAorfTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
aWRlL3BjaS92aWE4MmN4eHguYyBiL2RyaXZlcnMvaWRlL3BjaS92aWE4MmN4eHguYwppbmRleCBh
MGQzYzE2Li44ZWJjODdlIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lkZS9wY2kvdmlhODJjeHh4LmMK
KysrIGIvZHJpdmVycy9pZGUvcGNpL3ZpYTgyY3h4eC5jCkBAIC00NzgsNiArNDc4LDEwIEBAIHN0
YXRpYyBpbnQgX19kZXZpbml0IHZpYV9pbml0X29uZShzdHJ1Y3QgcGNpX2RldiAqZGV2LCBjb25z
dCBzdHJ1Y3QgcGNpX2RldmljZV9pCiAJaWYgKG1hY2hpbmVfaXMoY2hycCkgJiYgX2NocnBfdHlw
ZSA9PSBfQ0hSUF9QZWdhc29zKQogCQlkLmhvc3RfZmxhZ3MgfD0gSURFX0hGTEFHX0ZPUkNFX0xF
R0FDWV9JUlFTOwogI2VuZGlmCisjaWZkZWYgQ09ORklHX0FNSUdBT05FCisJaWYgKG1hY2hpbmVf
aXMoYW1pZ2FvbmUpKQorCQlkLmhvc3RfZmxhZ3MgfD0gSURFX0hGTEFHX0ZPUkNFX0xFR0FDWV9J
UlFTOworI2VuZGlmCiAKIAlkLnVkbWFfbWFzayA9IHZpYV9jb25maWctPnVkbWFfbWFzazsKIApk
aWZmIC0tZ2l0IGEvZHJpdmVycy9pbnB1dC9taXNjL0tjb25maWcgYi9kcml2ZXJzL2lucHV0L21p
c2MvS2NvbmZpZwppbmRleCA4ZjVjN2I5Li45NzE2ZDc2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2lu
cHV0L21pc2MvS2NvbmZpZworKysgYi9kcml2ZXJzL2lucHV0L21pc2MvS2NvbmZpZwpAQCAtMTQs
NyArMTQsNyBAQCBpZiBJTlBVVF9NSVNDCiAKIGNvbmZpZyBJTlBVVF9QQ1NQS1IKIAl0cmlzdGF0
ZSAiUEMgU3BlYWtlciBzdXBwb3J0IgotCWRlcGVuZHMgb24gQUxQSEEgfHwgWDg2IHx8IE1JUFMg
fHwgUFBDX1BSRVAgfHwgUFBDX0NIUlAgfHwgUFBDX1BTRVJJRVMKKwlkZXBlbmRzIG9uIEFMUEhB
IHx8IFg4NiB8fCBNSVBTIHx8IFBQQ19QUkVQIHx8IFBQQ19DSFJQIHx8IFBQQ19QU0VSSUVTIHx8
IEFNSUdBT05FCiAJaGVscAogCSAgU2F5IFkgaGVyZSBpZiB5b3Ugd2FudCB0aGUgc3RhbmRhcmQg
UEMgU3BlYWtlciB0byBiZSB1c2VkIGZvcgogCSAgYmVsbHMgYW5kIHdoaXN0bGVzLgo=
--========GMX220631202253421230786--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbXIJAtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbXIJAtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 20:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXIJAtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 20:49:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:37365 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbXIJAtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 20:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=p6yN9jJmLskhAp6QGtekyG0zSbjxP9LKPaC/KeWGT6r0ZUT99Q5vujNsg4Iqu90rVlH3iDcy6SElAPn5j9JxXIKY+onX/BYlZigkSbkfQgk0QdU08A4/7VRc9N0k70/XH2NzV+FqpS8EdOXleGdwb2/n7WoBxtK1I/o9HTYiprk=
Message-ID: <34d269d40709091749i1541b821j1d26b11cd22cd239@mail.gmail.com>
Date: Sun, 9 Sep 2007 18:49:12 -0600
From: "Alex Hunsaker" <badalex@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Secure defaults (initial sysctl settings)
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5052_7499347.1189385352679"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5052_7499347.1189385352679
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Allow for various sysctl settings to initially be set to more secure
defaults.

Why: While you can easily set these values at boot time with sysctl
(and most distros do).
-Its nice to be able to set their initial value.
-It also allows someone who is unfamiliar with all the security knobs
the kernel exposes to easily turn one on or off (or even read about
what it does).
-Another benefit is every time a new security feature comes out
(mmap_min_addr for example) you don't have to change the setting on
every server.  Or heck even be totally unaware of it until you read
about it on <insert favorite news source> months later.

While some options (syncookies comes to mind) might be better places
somewhere else...
Im more interested to see if anyone thinks this is a good idea.
I mainly did this because I wanted a way to turn on mmap_min_addr by default.
After which i thought hrm, what other sysctl settings do I regularly
change the default setting...

Also it *seems* like it might be nice to move other security related
(fstack-protector, seecomp) under Security.
What does everyone else think?

Oh and sorry about the gross use of Kconfig CONFIG_ defines, whats a
better way to do this?  static inlines #ifdef CONFIG_XXX in the
headers?

Signed-off-by: Alex Hunsaker <badalex@gmail.com>

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 5b77bda..438eb1d 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -65,20 +65,24 @@

 struct ipv4_devconf ipv4_devconf = {
    .data = {
-       [NET_IPV4_CONF_ACCEPT_REDIRECTS - 1] = 1,
-       [NET_IPV4_CONF_SEND_REDIRECTS - 1] = 1,
+       [NET_IPV4_CONF_ACCEPT_REDIRECTS - 1] = CONFIG_IPV4_ACCEPT_REDIRECTS,
+       [NET_IPV4_CONF_SEND_REDIRECTS - 1] = CONFIG_IPV4_SEND_REDIRECTS,
        [NET_IPV4_CONF_SECURE_REDIRECTS - 1] = 1,
        [NET_IPV4_CONF_SHARED_MEDIA - 1] = 1,
+       [NET_IPV4_CONF_LOG_MARTIANS - 1] = CONFIG_IPV4_LOG_MARTIANS,
+       [NET_IPV4_CONF_RP_FILTER - 1] = CONFIG_IPV4_RP_FILTER,
    },
 };

 static struct ipv4_devconf ipv4_devconf_dflt = {
    .data = {
-       [NET_IPV4_CONF_ACCEPT_REDIRECTS - 1] = 1,
-       [NET_IPV4_CONF_SEND_REDIRECTS - 1] = 1,
+       [NET_IPV4_CONF_ACCEPT_REDIRECTS - 1] = CONFIG_IPV4_ACCEPT_REDIRECTS,
+       [NET_IPV4_CONF_SEND_REDIRECTS - 1] = CONFIG_IPV4_SEND_REDIRECTS,
        [NET_IPV4_CONF_SECURE_REDIRECTS - 1] = 1,
        [NET_IPV4_CONF_SHARED_MEDIA - 1] = 1,
-       [NET_IPV4_CONF_ACCEPT_SOURCE_ROUTE - 1] = 1,
+       [NET_IPV4_CONF_ACCEPT_SOURCE_ROUTE - 1] =
CONFIG_IPV4_ACCEPT_SOURCE_ROUTE,
+       [NET_IPV4_CONF_LOG_MARTIANS - 1] = CONFIG_IPV4_LOG_MARTIANS,
+       [NET_IPV4_CONF_RP_FILTER - 1] = CONFIG_IPV4_RP_FILTER,
    },
 };

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index a12b08f..99e29e5 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -29,7 +29,7 @@
 #include <net/xfrm.h>

 #ifdef CONFIG_SYSCTL
-#define SYNC_INIT 0 /* let the user enable it */
+#define SYNC_INIT CONFIG_TCP_SYNCOOKIES_ON
 #else
 #define SYNC_INIT 1
 #endif
diff --git a/security/Kconfig b/security/Kconfig
index 460e5c9..e469dd6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -93,6 +93,8 @@ config SECURITY_ROOTPLUG

      If you are unsure how to answer this question, answer N.

+source security/Kconfig.secure_defaults
+
 source security/selinux/Kconfig

 endmenu
diff --git a/security/Kconfig.secure_defaults b/security/Kconfig.secure_defaults
new file mode 100644
index 0000000..2b2199e
--- /dev/null
+++ b/security/Kconfig.secure_defaults
@@ -0,0 +1,92 @@
+config SECURITY_SECURE_DEFAULTS
+   tristate "Secure defaults"
+   depends on SECURITY
+   help
+       Allows tuning of various kernel knobs to be secure by default.
+       NOTE: all of these have equivalent sysctl options
+
+config SECURITY_MMAP_MIN_ADDR
+   int "default mmap min address"
+   help
+     Help prevent users from exploiting NULL dereferences in the
kernel which have
+     not been discovered yet.
+   range 0 65536
+   depends on SECURITY_SECURE_DEFAULTS
+   default "4096"
+
+
+config SECURITY_TCP_SYNCOOKIES
+   bool "Turn on syncookies by default"
+   help
+     Syncookies can help prevent syn-flood attacks
+     (see Documentation/networking/ip-sysctl.txt for more)
+   depends on SYN_COOKIES
+   depends on SECURITY_SECURE_DEFAULTS
+   default y
+
+config TCP_SYNCOOKIES_ON
+   int
+   default 1 if SECURITY_TCP_SYNCOOKIES
+   default 0
+
+config SECURITY_IPV4_NO_ACCEPT_REDIRECTS
+   bool "Don't accept IMCP redirects"
+   help
+     ICMP redirects can be used to set up MITM attacks and other nasties
+   depends on SECURITY_SECURE_DEFAULTS
+   default y
+
+config IPV4_ACCEPT_REDIRECTS
+   int
+   default 0 if SECURITY_IPV4_NO_ACCEPT_REDIRECTS
+   default 1
+
+config SECURITY_IPV4_NO_SEND_REDIRECTS
+   bool "Don't send IMCP redirects"
+   help
+      Usually only needed if this computer functions as a router of some sort.
+   depends on SECURITY_SECURE_DEFAULTS
+   default y
+
+config IPV4_SEND_REDIRECTS
+   int
+   default 0 if SECURITY_IPV4_NO_SEND_REDIRECTS
+   default 1
+
+config SECURITY_IPV4_NO_ACCEPT_SOURCE_ROUTE
+   bool "Don't accept source routes"
+   help
+     source routed packets are generally not needed and could
potently allow MITM attacks.
+   depends on SECURITY_SECURE_DEFAULTS
+   default y
+
+config IPV4_ACCEPT_SOURCE_ROUTE
+   int
+   default 0 if SECURITY_IPV4_NO_ACCEPT_SOURE_ROUTE
+   default 1
+
+config SECURITY_IPV4_LOG_MARTIANS
+   bool "Log martians by default"
+   depends on SECURITY_SECURE_DEFAULTS
+   help
+     Log packets with impossible addresses to the kernel log
+   default y
+
+config IPV4_LOG_MARTIANS
+   int
+   default 1 if SECURITY_IPV4_LOG_MARTIANS
+   default 0
+
+config SECURITY_IPV4_RP_FILTER
+   bool "Turn on rp_filter by default"
+   depends on SECURITY_SECURE_DEFAULTS
+   help
+     Help protect against spoofed tcp/ip packets.
+     Could cause troubles for complicated networks.
+     (see Documentation/networking/ip-sysctl.txt for more)
+   default y
+
+config IPV4_RP_FILTER
+   int
+   default 1 if SECURITY_IPV4_RP_FILTER
+   default 0
diff --git a/security/security.c b/security/security.c
index 27e5863..d82088c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -64,6 +64,8 @@ int __init security_init(void)
    security_ops = &dummy_security_ops;
    do_security_initcalls();

+   mmap_min_addr = CONFIG_SECURITY_MMAP_MIN_ADDR;
+
    return 0;
 }

------=_Part_5052_7499347.1189385352679
Content-Type: application/octet-stream; name="secure-defaults.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="secure-defaults.patch"
X-Attachment-Id: f_f6e99z0y

QWxsb3cgZm9yIHZhcmlvdXMgc3lzY3RsIHNldHRpbmdzIHRvIGluaXRpYWxseSBiZSBzZXQgdG8g
bW9yZSBzZWN1cmUgZGVmYXVsdHMuCgpXaHk6IFdoaWxlIHlvdSBjYW4gZWFzaWx5IHNldCB0aGVz
ZSB2YWx1ZXMgYXQgYm9vdCB0aW1lIHdpdGggc3lzY3RsIChhbmQgbW9zdCBkaXN0cm9zIGRvKS4K
LUl0cyBuaWNlIHRvIGJlIGFibGUgdG8gc2V0IHRoZWlyIGluaXRpYWwgdmFsdWUuCi1JdCBhbHNv
IGFsbG93cyBzb21lb25lIHdobyBpcyB1bmZhbWlsaWFyIHdpdGggYWxsIHRoZSBzZWN1cml0eSBr
bm9icyB0aGUga2VybmVsIGV4cG9zZXMgdG8gZWFzaWx5IHR1cm4gb25lIG9uIG9yIG9mZiAob3Ig
ZXZlbiByZWFkIGFib3V0IHdoYXQgaXQgZG9lcykuCi1Bbm90aGVyIGJlbmVmaXQgaXMgZXZlcnkg
dGltZSBhIG5ldyBzZWN1cml0eSBmZWF0dXJlIGNvbWVzIG91dCAobW1hcF9taW5fYWRkciBmb3Ig
ZXhhbXBsZSkgeW91IGRvbid0IGhhdmUgdG8gY2hhbmdlIHRoZSBzZXR0aW5nIG9uIGV2ZXJ5IHNl
cnZlci4gIE9yIGhlY2sgZXZlbiBiZSB0b3RhbGx5IHVuYXdhcmUgb2YgaXQgdW50aWwgeW91IHJl
YWQgYWJvdXQgaXQgb24gPGluc2VydCBmYXZvcml0ZSBuZXdzIHNvdXJjZT4gbW9udGhzIGxhdGVy
LgoKV2hpbGUgc29tZSBvcHRpb25zIChzeW5jb29raWVzIGNvbWVzIHRvIG1pbmQpIG1pZ2h0IGJl
IGJldHRlciBwbGFjZXMgc29tZXdoZXJlIGVsc2UuLi4KSW0gbW9yZSBpbnRlcmVzdGVkIHRvIHNl
ZSBpZiBhbnlvbmUgdGhpbmtzIHRoaXMgaXMgYSBnb29kIGlkZWEuCkkgbWFpbmx5IGRpZCB0aGlz
IGJlY2F1c2UgSSB3YW50ZWQgYSB3YXkgdG8gdHVybiBvbiBtbWFwX21pbl9hZGRyIGJ5IGRlZmF1
bHQuCkFmdGVyIHdoaWNoIGkgdGhvdWdodCBocm0sIHdoYXQgb3RoZXIgc3lzY3RsIHNldHRpbmdz
IGRvIEkgcmVndWxhcmx5IGNoYW5nZSB0aGUgZGVmYXVsdCBzZXR0aW5nLi4uCgpBbHNvIGl0ICpz
ZWVtcyogbGlrZSBpdCBtaWdodCBiZSBuaWNlIHRvIG1vdmUgb3RoZXIgc2VjdXJpdHkgcmVsYXRl
ZCAoZnN0YWNrLXByb3RlY3Rvciwgc2VlY29tcCkgdW5kZXIgU2VjdXJpdHkuCldoYXQgZG9lcyBl
dmVyeW9uZSBlbHNlIHRoaW5rPwoKT2ggYW5kIHNvcnJ5IGFib3V0IHRoZSBncm9zcyB1c2Ugb2Yg
S2NvbmZpZyBDT05GSUdfIGRlZmluZXMsIHdoYXRzIGEgYmV0dGVyIHdheSB0byBkbyB0aGlzPyAg
c3RhdGljIGlubGluZXMgI2lmZGVmIENPTkZJR19YWFggaW4gdGhlIGhlYWRlcnM/CgpTaWduZWQt
b2ZmLWJ5OiBBbGV4IEh1bnNha2VyIDxiYWRhbGV4QGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9u
ZXQvaXB2NC9kZXZpbmV0LmMgYi9uZXQvaXB2NC9kZXZpbmV0LmMKaW5kZXggNWI3N2JkYS4uNDM4
ZWIxZCAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvZGV2aW5ldC5jCisrKyBiL25ldC9pcHY0L2Rldmlu
ZXQuYwpAQCAtNjUsMjAgKzY1LDI0IEBACiAKIHN0cnVjdCBpcHY0X2RldmNvbmYgaXB2NF9kZXZj
b25mID0gewogCS5kYXRhID0gewotCQlbTkVUX0lQVjRfQ09ORl9BQ0NFUFRfUkVESVJFQ1RTIC0g
MV0gPSAxLAotCQlbTkVUX0lQVjRfQ09ORl9TRU5EX1JFRElSRUNUUyAtIDFdID0gMSwKKwkJW05F
VF9JUFY0X0NPTkZfQUNDRVBUX1JFRElSRUNUUyAtIDFdID0gQ09ORklHX0lQVjRfQUNDRVBUX1JF
RElSRUNUUywKKwkJW05FVF9JUFY0X0NPTkZfU0VORF9SRURJUkVDVFMgLSAxXSA9IENPTkZJR19J
UFY0X1NFTkRfUkVESVJFQ1RTLAogCQlbTkVUX0lQVjRfQ09ORl9TRUNVUkVfUkVESVJFQ1RTIC0g
MV0gPSAxLAogCQlbTkVUX0lQVjRfQ09ORl9TSEFSRURfTUVESUEgLSAxXSA9IDEsCisJCVtORVRf
SVBWNF9DT05GX0xPR19NQVJUSUFOUyAtIDFdID0gQ09ORklHX0lQVjRfTE9HX01BUlRJQU5TLAor
CQlbTkVUX0lQVjRfQ09ORl9SUF9GSUxURVIgLSAxXSA9IENPTkZJR19JUFY0X1JQX0ZJTFRFUiwK
IAl9LAogfTsKIAogc3RhdGljIHN0cnVjdCBpcHY0X2RldmNvbmYgaXB2NF9kZXZjb25mX2RmbHQg
PSB7CiAJLmRhdGEgPSB7Ci0JCVtORVRfSVBWNF9DT05GX0FDQ0VQVF9SRURJUkVDVFMgLSAxXSA9
IDEsCi0JCVtORVRfSVBWNF9DT05GX1NFTkRfUkVESVJFQ1RTIC0gMV0gPSAxLAorCQlbTkVUX0lQ
VjRfQ09ORl9BQ0NFUFRfUkVESVJFQ1RTIC0gMV0gPSBDT05GSUdfSVBWNF9BQ0NFUFRfUkVESVJF
Q1RTLAorCQlbTkVUX0lQVjRfQ09ORl9TRU5EX1JFRElSRUNUUyAtIDFdID0gQ09ORklHX0lQVjRf
U0VORF9SRURJUkVDVFMsCiAJCVtORVRfSVBWNF9DT05GX1NFQ1VSRV9SRURJUkVDVFMgLSAxXSA9
IDEsCiAJCVtORVRfSVBWNF9DT05GX1NIQVJFRF9NRURJQSAtIDFdID0gMSwKLQkJW05FVF9JUFY0
X0NPTkZfQUNDRVBUX1NPVVJDRV9ST1VURSAtIDFdID0gMSwKKwkJW05FVF9JUFY0X0NPTkZfQUND
RVBUX1NPVVJDRV9ST1VURSAtIDFdID0gQ09ORklHX0lQVjRfQUNDRVBUX1NPVVJDRV9ST1VURSwK
KwkJW05FVF9JUFY0X0NPTkZfTE9HX01BUlRJQU5TIC0gMV0gPSBDT05GSUdfSVBWNF9MT0dfTUFS
VElBTlMsCisJCVtORVRfSVBWNF9DT05GX1JQX0ZJTFRFUiAtIDFdID0gQ09ORklHX0lQVjRfUlBf
RklMVEVSLAogCX0sCiB9OwogCmRpZmYgLS1naXQgYS9uZXQvaXB2NC90Y3BfbWluaXNvY2tzLmMg
Yi9uZXQvaXB2NC90Y3BfbWluaXNvY2tzLmMKaW5kZXggYTEyYjA4Zi4uOTllMjllNSAxMDA2NDQK
LS0tIGEvbmV0L2lwdjQvdGNwX21pbmlzb2Nrcy5jCisrKyBiL25ldC9pcHY0L3RjcF9taW5pc29j
a3MuYwpAQCAtMjksNyArMjksNyBAQAogI2luY2x1ZGUgPG5ldC94ZnJtLmg+CiAKICNpZmRlZiBD
T05GSUdfU1lTQ1RMCi0jZGVmaW5lIFNZTkNfSU5JVCAwIC8qIGxldCB0aGUgdXNlciBlbmFibGUg
aXQgKi8KKyNkZWZpbmUgU1lOQ19JTklUIENPTkZJR19UQ1BfU1lOQ09PS0lFU19PTgogI2Vsc2UK
ICNkZWZpbmUgU1lOQ19JTklUIDEKICNlbmRpZgpkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvS2NvbmZp
ZyBiL3NlY3VyaXR5L0tjb25maWcKaW5kZXggNDYwZTVjOS4uZTQ2OWRkNiAxMDA2NDQKLS0tIGEv
c2VjdXJpdHkvS2NvbmZpZworKysgYi9zZWN1cml0eS9LY29uZmlnCkBAIC05Myw2ICs5Myw4IEBA
IGNvbmZpZyBTRUNVUklUWV9ST09UUExVRwogCSAgCiAJICBJZiB5b3UgYXJlIHVuc3VyZSBob3cg
dG8gYW5zd2VyIHRoaXMgcXVlc3Rpb24sIGFuc3dlciBOLgogCitzb3VyY2Ugc2VjdXJpdHkvS2Nv
bmZpZy5zZWN1cmVfZGVmYXVsdHMKKwogc291cmNlIHNlY3VyaXR5L3NlbGludXgvS2NvbmZpZwog
CiBlbmRtZW51CmRpZmYgLS1naXQgYS9zZWN1cml0eS9LY29uZmlnLnNlY3VyZV9kZWZhdWx0cyBi
L3NlY3VyaXR5L0tjb25maWcuc2VjdXJlX2RlZmF1bHRzCm5ldyBmaWxlIG1vZGUgMTAwNjQ0Cmlu
ZGV4IDAwMDAwMDAuLjJiMjE5OWUKLS0tIC9kZXYvbnVsbAorKysgYi9zZWN1cml0eS9LY29uZmln
LnNlY3VyZV9kZWZhdWx0cwpAQCAtMCwwICsxLDkyIEBACitjb25maWcgU0VDVVJJVFlfU0VDVVJF
X0RFRkFVTFRTCisJdHJpc3RhdGUgIlNlY3VyZSBkZWZhdWx0cyIKKwlkZXBlbmRzIG9uIFNFQ1VS
SVRZCisJaGVscAorCQlBbGxvd3MgdHVuaW5nIG9mIHZhcmlvdXMga2VybmVsIGtub2JzIHRvIGJl
IHNlY3VyZSBieSBkZWZhdWx0LgorCQlOT1RFOiBhbGwgb2YgdGhlc2UgaGF2ZSBlcXVpdmFsZW50
IHN5c2N0bCBvcHRpb25zCisKK2NvbmZpZyBTRUNVUklUWV9NTUFQX01JTl9BRERSCisJaW50ICJk
ZWZhdWx0IG1tYXAgbWluIGFkZHJlc3MiCisJaGVscAorCSAgSGVscCBwcmV2ZW50IHVzZXJzIGZy
b20gZXhwbG9pdGluZyBOVUxMIGRlcmVmZXJlbmNlcyBpbiB0aGUga2VybmVsIHdoaWNoIGhhdmUK
KwkgIG5vdCBiZWVuIGRpc2NvdmVyZWQgeWV0LgorCXJhbmdlIDAgNjU1MzYKKwlkZXBlbmRzIG9u
IFNFQ1VSSVRZX1NFQ1VSRV9ERUZBVUxUUworCWRlZmF1bHQgIjQwOTYiCisKKworY29uZmlnIFNF
Q1VSSVRZX1RDUF9TWU5DT09LSUVTCisJYm9vbCAiVHVybiBvbiBzeW5jb29raWVzIGJ5IGRlZmF1
bHQiCisJaGVscAorCSAgU3luY29va2llcyBjYW4gaGVscCBwcmV2ZW50IHN5bi1mbG9vZCBhdHRh
Y2tzCisJICAoc2VlIERvY3VtZW50YXRpb24vbmV0d29ya2luZy9pcC1zeXNjdGwudHh0IGZvciBt
b3JlKQorCWRlcGVuZHMgb24gU1lOX0NPT0tJRVMKKwlkZXBlbmRzIG9uIFNFQ1VSSVRZX1NFQ1VS
RV9ERUZBVUxUUworCWRlZmF1bHQgeQorCitjb25maWcgVENQX1NZTkNPT0tJRVNfT04KKwlpbnQK
KwlkZWZhdWx0IDEgaWYgU0VDVVJJVFlfVENQX1NZTkNPT0tJRVMKKwlkZWZhdWx0IDAKKworY29u
ZmlnIFNFQ1VSSVRZX0lQVjRfTk9fQUNDRVBUX1JFRElSRUNUUworCWJvb2wgIkRvbid0IGFjY2Vw
dCBJTUNQIHJlZGlyZWN0cyIKKwloZWxwCisJICBJQ01QIHJlZGlyZWN0cyBjYW4gYmUgdXNlZCB0
byBzZXQgdXAgTUlUTSBhdHRhY2tzIGFuZCBvdGhlciBuYXN0aWVzCisJZGVwZW5kcyBvbiBTRUNV
UklUWV9TRUNVUkVfREVGQVVMVFMKKwlkZWZhdWx0IHkKKworY29uZmlnIElQVjRfQUNDRVBUX1JF
RElSRUNUUworCWludAorCWRlZmF1bHQgMCBpZiBTRUNVUklUWV9JUFY0X05PX0FDQ0VQVF9SRURJ
UkVDVFMKKwlkZWZhdWx0IDEKKworY29uZmlnIFNFQ1VSSVRZX0lQVjRfTk9fU0VORF9SRURJUkVD
VFMKKwlib29sICJEb24ndCBzZW5kIElNQ1AgcmVkaXJlY3RzIgorCWhlbHAKKwkgICBVc3VhbGx5
IG9ubHkgbmVlZGVkIGlmIHRoaXMgY29tcHV0ZXIgZnVuY3Rpb25zIGFzIGEgcm91dGVyIG9mIHNv
bWUgc29ydC4KKwlkZXBlbmRzIG9uIFNFQ1VSSVRZX1NFQ1VSRV9ERUZBVUxUUworCWRlZmF1bHQg
eQorCitjb25maWcgSVBWNF9TRU5EX1JFRElSRUNUUworCWludAorCWRlZmF1bHQgMCBpZiBTRUNV
UklUWV9JUFY0X05PX1NFTkRfUkVESVJFQ1RTCisJZGVmYXVsdCAxCisKK2NvbmZpZyBTRUNVUklU
WV9JUFY0X05PX0FDQ0VQVF9TT1VSQ0VfUk9VVEUKKwlib29sICJEb24ndCBhY2NlcHQgc291cmNl
IHJvdXRlcyIKKwloZWxwCisJICBzb3VyY2Ugcm91dGVkIHBhY2tldHMgYXJlIGdlbmVyYWxseSBu
b3QgbmVlZGVkIGFuZCBjb3VsZCBwb3RlbnRseSBhbGxvdyBNSVRNIGF0dGFja3MuCisJZGVwZW5k
cyBvbiBTRUNVUklUWV9TRUNVUkVfREVGQVVMVFMKKwlkZWZhdWx0IHkKKworY29uZmlnIElQVjRf
QUNDRVBUX1NPVVJDRV9ST1VURQorCWludAorCWRlZmF1bHQgMCBpZiBTRUNVUklUWV9JUFY0X05P
X0FDQ0VQVF9TT1VSRV9ST1VURQorCWRlZmF1bHQgMQorCitjb25maWcgU0VDVVJJVFlfSVBWNF9M
T0dfTUFSVElBTlMKKwlib29sICJMb2cgbWFydGlhbnMgYnkgZGVmYXVsdCIKKwlkZXBlbmRzIG9u
IFNFQ1VSSVRZX1NFQ1VSRV9ERUZBVUxUUworCWhlbHAKKwkgIExvZyBwYWNrZXRzIHdpdGggaW1w
b3NzaWJsZSBhZGRyZXNzZXMgdG8gdGhlIGtlcm5lbCBsb2cKKwlkZWZhdWx0IHkKKworY29uZmln
IElQVjRfTE9HX01BUlRJQU5TCisJaW50CisJZGVmYXVsdCAxIGlmIFNFQ1VSSVRZX0lQVjRfTE9H
X01BUlRJQU5TCisJZGVmYXVsdCAwCisKK2NvbmZpZyBTRUNVUklUWV9JUFY0X1JQX0ZJTFRFUgor
CWJvb2wgIlR1cm4gb24gcnBfZmlsdGVyIGJ5IGRlZmF1bHQiCisJZGVwZW5kcyBvbiBTRUNVUklU
WV9TRUNVUkVfREVGQVVMVFMKKwloZWxwCisJICBIZWxwIHByb3RlY3QgYWdhaW5zdCBzcG9vZmVk
IHRjcC9pcCBwYWNrZXRzLgorCSAgQ291bGQgY2F1c2UgdHJvdWJsZXMgZm9yIGNvbXBsaWNhdGVk
IG5ldHdvcmtzLgorCSAgKHNlZSBEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvaXAtc3lzY3RsLnR4
dCBmb3IgbW9yZSkKKwlkZWZhdWx0IHkKKworY29uZmlnIElQVjRfUlBfRklMVEVSCisJaW50CisJ
ZGVmYXVsdCAxIGlmIFNFQ1VSSVRZX0lQVjRfUlBfRklMVEVSCisJZGVmYXVsdCAwCmRpZmYgLS1n
aXQgYS9zZWN1cml0eS9zZWN1cml0eS5jIGIvc2VjdXJpdHkvc2VjdXJpdHkuYwppbmRleCAyN2U1
ODYzLi5kODIwODhjIDEwMDY0NAotLS0gYS9zZWN1cml0eS9zZWN1cml0eS5jCisrKyBiL3NlY3Vy
aXR5L3NlY3VyaXR5LmMKQEAgLTY0LDYgKzY0LDggQEAgaW50IF9faW5pdCBzZWN1cml0eV9pbml0
KHZvaWQpCiAJc2VjdXJpdHlfb3BzID0gJmR1bW15X3NlY3VyaXR5X29wczsKIAlkb19zZWN1cml0
eV9pbml0Y2FsbHMoKTsKIAorCW1tYXBfbWluX2FkZHIgPSBDT05GSUdfU0VDVVJJVFlfTU1BUF9N
SU5fQUREUjsKKwogCXJldHVybiAwOwogfQogCg==
------=_Part_5052_7499347.1189385352679--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbXFNC2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbXFNC2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbXFNC2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:28:09 -0400
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:39745 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXFNC2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:28:08 -0400
Message-ID: <4670A759.7090206@soft.fujitsu.com>
Date: Thu, 14 Jun 2007 11:26:33 +0900
From: izumi <izumi2005@soft.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH][BUG] Fix the graphic corruption issue on IA64 machines
Content-Type: multipart/mixed;
 boundary="------------090702090901060800060005"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090702090901060800060005
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I encountered the graphic corruption issue on IA64 machines by the
following operations.

 0. enable VGA console(default setting). disable serial console setting.
 1. boot the system at run level 3 and login via text-mode console
(/dev/tty1)
    as the root user.
 2. disable console blanking.
    # setterm -blank 0
 3. start X.
 4. shutdown X.
 5. start X again.
 6. open the gnome-terminal and write someting to /dev/console.
    # ls -l  > /dev/console

The cause of this problem may be VGA console driver's misunderstanding
mode(text/graphic).

I confirmed this problem is fixed by the attached patch, but I don't
know this is the correct fix.

--------------------------------------------------------------------

VGA console driver can misunderstand the current mode(Text/Graphic) under
"disable console blanking" setting.

- start X
  -->  vt_ioctl()    drivers/char/vt_ioctl.c
        do_blank_screen(1)     drivers/char/vt.c
           sw->con_blank(vc_cons[currcons].d, 1, 0)  drivers/char/vt.c
       vgacon_blank()     drivers/video/console/vgacon.c
　        vga_is_gfx = 1 /* enter Graphic mode */

- shutdown X
  -->   vt_ioctl()
          do_unblank_screen(1)    drivers/char/vt.c
            sw->con_blank(vc_cons[currcons].d, 0, leaving_gfx)
        vgacon_blank()
　         vga_is_gfx = 0 /* leave Graphic mode */

When "disable console blank" is set (=> blankinterval=0),
"do_unblank_screen()" function
returns without changing "blank_state", and when "blank_state" is
"blank_off",
"do_blank_screen() function returns without invoking sw->con_blank()
function.
That's why VGA console driver can misunderstand the current mode.

-----------------------------------------------------------------------

Regards,
Taku Izumi


--------------090702090901060800060005
Content-Type: text/plain;
 name="vt-blank.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="vt-blank.patch"

Rml4IHRoZSBncmFwaGljIGNvcnJ1cHRpb24gaXNzdWUgb24gSUE2NCBtYWNoaW5lcy4KVkdB
IGNvbnNvbGUgZHJpdmVyIGNhbiBtaXN1bmRlcnN0YW5kIHRoZSBjdXJyZW50IG1vZGUoVGV4
dC9HcmFwaGljKSB1bmRlciAKImRpc2FibGUgY29uc29sZSBibGFua2luZyIgc2V0dGluZy4g
V2hlbiAiZGlzYWJsZSBjb25zb2xlIGJsYW5rIiBpcyBzZXQgKGJsYW5raW50ZXJ2YWw9MCks
ICJkb191bmJsYW5rX3NjcmVlbigpIiBmdW5jdGlvbiByZXR1cm5zIHdpdGhvdXQgY2hhbmdp
bmcgImJsYW5rX3N0YXRlIiwgYW5kIHdoZW4gImJsYW5rX3N0YXRlIiBpcyAiYmxhbmtfb2Zm
IiwgImRvX2JsYW5rX3NjcmVlbigpIGZ1bmN0aW9uIHJldHVybnMgd2l0aG91dCBpbnZva2lu
ZyBzdy0+Y29uX2JsYW5rKCkgZnVuY3Rpb24uIFRoYXQncyB3aHkgVkdBIGNvbnNvbGUgZHJp
dmVyIGNhbiBtaXN1bmRlcnN0YW5kIHRoZSBjdXJyZW50IG1vZGUuCgpTaWduZWQtb2ZmLWJ5
OiBOb2J1aGlybyBUYWNoaW5vIDxudGFjaGlub0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5
OiBUYWt1IEl6dW1pIDxpenVtaTIwMDVAc29mdC5mdWppdHN1LmNvbT4KLS0tCiBkcml2ZXJz
L2NoYXIvdnQuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkKCgpJbmRleDogbGludXgtMi42LjIxLjUvZHJpdmVycy9jaGFyL3Z0
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjEuNS5vcmcvZHJpdmVycy9j
aGFyL3Z0LmMJMjAwNy0wNi0xMyAxMjowMzoxMS4wMDAwMDAwMDAgKzA5MDAKKysrIGxpbnV4
LTIuNi4yMS41L2RyaXZlcnMvY2hhci92dC5jCTIwMDctMDYtMTMgMTI6MDc6NDguMDAwMDAw
MDAwICswOTAwCkBAIC0zNDE5LDEyICszNDE5LDEyIEBAIHZvaWQgZG9fdW5ibGFua19zY3Jl
ZW4oaW50IGxlYXZpbmdfZ2Z4KQogCQlyZXR1cm47CiAJfQogCXZjID0gdmNfY29uc1tmZ19j
b25zb2xlXS5kOworCWJsYW5rX3N0YXRlID0gYmxhbmtfbm9ybWFsX3dhaXQ7CiAJaWYgKHZj
LT52Y19tb2RlICE9IEtEX1RFWFQpCiAJCXJldHVybjsgLyogYnV0IGxlYXZlIGNvbnNvbGVf
YmxhbmtlZCAhPSAwICovCiAKIAlpZiAoYmxhbmtpbnRlcnZhbCkgewogCQltb2RfdGltZXIo
JmNvbnNvbGVfdGltZXIsIGppZmZpZXMgKyBibGFua2ludGVydmFsKTsKLQkJYmxhbmtfc3Rh
dGUgPSBibGFua19ub3JtYWxfd2FpdDsKIAl9CiAKIAljb25zb2xlX2JsYW5rZWQgPSAwOwo=
--------------090702090901060800060005--


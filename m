Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXJTBH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXJTBH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXJTBHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:07:13 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:41131 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751312AbXJTBHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:07:11 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 21:07:11 EDT
X-YMail-OSG: zar.7OAVM1lrce4D6_cR9D1h_DCaxoPqY3QhPSDrVinjZPDPHb1MTcbU.xJcBZ2cosiCVgIqhwV6pXncZ0WVkmBXDfPwOf7Gujgk1C.qBKxwxWdBcg--
Message-ID: <4719532A.6080704@andrei.myip.org>
Date: Fri, 19 Oct 2007 18:00:26 -0700
From: Florin Andrei <florin@andrei.myip.org>
Reply-To: linux-kernel@vger.kernel.org
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: enhancements to the RPM spec file generator
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florin Andrei <florin@andrei.myip.org>

"make rpm" creates a plain package that does not update grub.conf
and does not create an initrd. This patch modifies scripts/package/mkspec
to create an RPM spec file that updates grub.conf after install/uninstall
and also that creates an initrd file after install. These new functions
are activated via an environment variable (export RPM_RH5_STYLE=true)
when running "make rpm".

Signed-off-by: Florin Andrei <florin@andrei.myip.org>
---

--- linux-2.6.23.1.orig/scripts/package/mkspec  2007-10-19 02:07:58.000000000 -0700
+++ linux-2.6.23.1/scripts/package/mkspec       2007-10-19 05:42:47.000000000 -0700
@@ -81,6 +81,11 @@ echo 'cp $KBUILD_IMAGE $RPM_BUILD_ROOT'"
 echo "%endif"
 echo "%endif"
 
+if $RPM_RH5_STYLE; then
+echo 'touch $RPM_BUILD_ROOT'"/boot/initrd-$KERNELRELEASE.img"
+echo 'gzip -c9 < Module.symvers > $RPM_BUILD_ROOT'"/boot/symvers-$KERNELRELEASE.gz"
+fi
+
 echo 'cp System.map $RPM_BUILD_ROOT'"/boot/System.map-$KERNELRELEASE"
 
 echo 'cp .config $RPM_BUILD_ROOT'"/boot/config-$KERNELRELEASE"
@@ -88,9 +93,44 @@ echo ""
 echo "%clean"
 echo '#echo -rf $RPM_BUILD_ROOT'
 echo ""
+
+if $RPM_RH5_STYLE; then
+cat <<RH5_POST_PREUN
+%post
+if [ `uname -i` == "x86_64" -o `uname -i` == "i386" ]; then
+  if [ -f /etc/sysconfig/kernel ]; then
+    /bin/sed -i -e 's/^DEFAULTKERNEL=kernel-smp$/DEFAULTKERNEL=kernel/' /etc/sysconfig/kernel || exit $?
+  fi
+fi
+/sbin/new-kernel-pkg --package kernel --mkinitrd --depmod --install $KERNELRELEASE || exit $?
+if [ -x /sbin/weak-modules ]
+then
+    /sbin/weak-modules --add-kernel $KERNELRELEASE || exit $?
+fi
+
+%preun
+/sbin/new-kernel-pkg --rminitrd --rmmoddep --remove $KERNELRELEASE || exit $?
+if [ -x /sbin/weak-modules ]
+then
+    /sbin/weak-modules --remove-kernel $KERNELRELEASE || exit $?
+fi
+
+RH5_POST_PREUN
+fi
+
 echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+if $RPM_RH5_STYLE; then
+cat <<RH5_FILES
+/boot/vmlinuz-$KERNELRELEASE
+/boot/System.map-$KERNELRELEASE
+/boot/symvers-$KERNELRELEASE.gz
+/boot/config-$KERNELRELEASE
+%ghost /boot/initrd-$KERNELRELEASE.img
+RH5_FILES
+else
 echo "/boot/*"
+fi
 echo ""


-- 
Florin Andrei

http://florin.myip.org/


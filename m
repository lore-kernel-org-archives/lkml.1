Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYCYUHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYCYUHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYCYUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:07:24 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:61814 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998AbYCYUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:07:23 -0400
Date: Tue, 25 Mar 2008 20:07:14 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Dave Airlie <airlied@gmail.com>
Cc: I2C <i2c@lm-sensors.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080325200714.GA25487@deepthought>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

 on one of my boxes, I've got a problem with gdm and kernels newer
than 2.6.24 (tested on 2.6.24.2, 2.6.24.4).  If I try to restart or
shut down from gdm, the window disappears but the X background remains
and the box stays in runlevel 5 until I switch to a tty and shut it
down (as root) or give it a 3-fingered salute to reboot.

 The same with 2.6.25-rc6-git8.

 The only oddity in the logs is a large block of
Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
'GET_CONFIG greeter/SetPosition :0'
Mar 24 13:49:29 bluesbreaker gdmlogin[2995]:   Got response: 'OK
false'
Mar 24 13:49:29 bluesbreaker gdmlogin[2995]: Sending command:
'CLOSE'
Mar 24 13:49:29 bluesbreaker gdm[2554]: Handling user message:
'CLOSE'
Mar 24 13:49:29 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
loop
Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
end verify for ''
Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
login/Bad login
Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
loop
Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login:
end verify for ''
Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: No
login/Bad login
Mar 24 13:49:35 bluesbreaker gdm[2562]: gdm_slave_wait_for_login: In
loop
... about 165 repeats of these 3 lines, it seems to stop the
messages on its own, then I ran shutdown and got the normal

Mar 24 13:50:02 bluesbreaker shutdown[3000]: shutting down for
system halt
Mar 24 13:50:02 bluesbreaker init: Switching to runlevel: 0
Mar 24 13:50:08 bluesbreaker logger: /etc/rc.d/init.d/rc called with
arg 0
Mar 24 13:50:08 bluesbreaker logger: /etc/rc.d/rc0.d/K01cups called
with arg stop
 and so forth.

 Yes, I've got a lot of debugging in there, I used this box to find
out why gdm-2.20 gave me a messy shutdown, and left it in after I
reverted to gdm-2.18.

 This only happens with 64-bit kernels, I've been using it as i686
without any issues.

 While trying to debug this, I reverted the two drm patches from
2.6.24.1 (in 2.6.24.4) and normal behaviour was restored.  I forgot
to change the extraversion, which meant my modules were overwritten.
When I later went back to the "bad 2.6.24.4" it shut down correctly.
Examination showed i2c_viapro was the key - if I rmmod it in
2.6.24.x, gdm works correctly.  For the record, my 32-bit config is
very different, but does include i2c_viapro as a module.

 So, I started to think it might be an i2c problem.  But with
2.6.25-rc6-git8 I can't get gdm to work correctly, neither by
reverting the patches, nor with rmmod, so for the moment I'm in the
dark.  My notes say that I managed to fix it one time on -rc6-git8,
by 'rmmod i2c_viapro' before logging out, but all subsequent attempts
to repeat this have failed.

 FWIW, the via ISA bridge is a 1106:3227 (VIA_8237, also
described as VT8237R in i2c-viapro).

 Going back to 2.6.24.4 and reverting only the following patch,
normal behaviour is restored:

diff --git a/drivers/char/drm/drm_vm.c b/drivers/char/drm/drm_vm.c
index e8d50af..ef5e6b1 100644
--- a/drivers/char/drm/drm_vm.c
+++ b/drivers/char/drm/drm_vm.c
@@ -506,6 +506,7 @@ static int drm_mmap_dma(struct file *filp,
struct vm_area_struct *vma)
        vma->vm_ops =3D &drm_vm_dma_ops;
=20
        vma->vm_flags |=3D VM_RESERVED;   /* Don't swap */
+       vma->vm_flags |=3D VM_DONTEXPAND;
=20
        vma->vm_file =3D filp;    /* Needed for drm_vm_open() */
        drm_vm_open_locked(vma);
@@ -655,6 +656,7 @@ static int drm_mmap_locked(struct file *filp,
struct vm_area_struct *vma)
                return -EINVAL; /* This should never happen. */
        }
        vma->vm_flags |=3D VM_RESERVED;   /* Don't swap */
+       vma->vm_flags |=3D VM_DONTEXPAND;
=20
        vma->vm_file =3D filp;    /* Needed for drm_vm_open() */
        drm_vm_open_locked(vma);

 I haven't been following 2.6.25 closely, but I assume that what got
applied to 2.6.24-stable was only part of the change to 2.6.25, and
perhaps some other part of it is affecting me ?

 .config.gz for 2.6.25-rc6-git8 is attached.

Ken
--=20
das eine Mal als Trag=F6die, das andere Mal als Farce

--pWyiEgJYm5f9v55/
Content-Type: application/x-gunzip
Content-Disposition: attachment; filename="config-2.6.25-rc6-git8-64.gz"
Content-Transfer-Encoding: base64

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
ka4VYX3gvf8DF5bbaGCpAAA=

--pWyiEgJYm5f9v55/--

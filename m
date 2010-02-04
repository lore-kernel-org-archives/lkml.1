Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0BDOYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:24:07 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52207 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0BDOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:24:05 -0500
Subject: Re: [PATCH] Bluetooth: Keep a copy of each HID device's report
 descriptor.
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Poole <mdpoole@troilus.org>
Cc: Bastien Nocera <hadess@hadess.net>, Jiri Kosina <jkosina@suse.cz>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <871vh1gpaz.fsf_-_@troilus.org>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <871vh1gpaz.fsf_-_@troilus.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 06:23:10 -0800
Message-ID: <1265293390.31341.156.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> This patch works for me.  Bastien, does it also fix it for you?
> 
> Michael Poole
> 
> From f8aeb64ac2d42f5fae080c00a287fdbd8304ffa2 Mon Sep 17 00:00:00 2001
> From: Michael Poole <mdpoole@troilus.org>
> Date: Wed, 3 Feb 2010 21:49:48 -0500
> Subject: [PATCH] Bluetooth: Keep a copy of each HID device's report descriptor.
> 
> The report descriptor is read by user space (via the Service
> Discovery Protocol), so it is only available during the ioctl
> to connect.  However, the probe function that needs the
> descriptor might not be called until a specific module is
> loaded.  Keep a copy of the descriptor so it is available for
> later use.

looks good to me. I just prefer that you do the allocation of the report
descriptor before the HID object:

@@ -770,12 +770,24 @@ static int hidp_setup_hid(struct hidp_session *session,
        bdaddr_t src, dst;
        int err;
 
+       session->rd_data = kzalloc(req->rd_size, GFP_KERNEL);
+       if (!session->rd_data)
+               return -ENOMEM;
+
+       if (copy_from_user(session->rd_data, req->rd_data, req->rd_size)) {
+               err = -EFAULT;
+               goto fault;
+       }
+
+       session->rd_size = req->rd_size;
+
        hid = hid_allocate_device();
-       if (IS_ERR(hid))
-               return PTR_ERR(hid);
+       if (IS_ERR(hid)) {
+               err = PTR_ERR(hid);
+               goto fault;
+       }
 
        session->hid = hid;
-       session->req = req;
        hid->driver_data = session;
 
        baswap(&src, &bt_sk(session->ctrl_sock->sk)->src);
@@ -806,6 +818,10 @@ failed:
        hid_destroy_device(hid);
        session->hid = NULL;
 
+fault:
+       kfree(session->rd_data);
+       session->rd_data = NULL;
+
        return err;

Regards

Marcel



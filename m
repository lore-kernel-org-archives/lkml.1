Return-Path: <linux-kernel-owner+w=401wt.eu-S1751167AbXBMHsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbXBMHsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXBMHsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:48:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60078 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXBMHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:48:00 -0500
Subject: dvb shared datastructure bug?
From: Arjan van de Ven <arjan@infradead.org>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 08:47:58 +0100
Message-Id: <1171352878.12771.30.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while working on the last pieces of the file_ops constantification, DVB
is the small village in France that is holding the Romans at bay... but
I think I found the final flaw in it now: 

       *pdvbdev = dvbdev = kmalloc(sizeof(struct dvb_device), GFP_KERNEL);

        if (!dvbdev) {
                mutex_unlock(&dvbdev_register_lock);
                return -ENOMEM;
        }

        memcpy(dvbdev, template, sizeof(struct dvb_device));
        dvbdev->type = type;
        dvbdev->id = id;
        dvbdev->adapter = adap;
        dvbdev->priv = priv;

        dvbdev->fops->owner = adap->module;


this is the place in DVB that is writing to a struct file_operations.
But as with almost all such cases in the kernel, this one is buggy:
While the code nicely copies a template dvbdev, that template only has a
pointer to a *shared* fops struct, the copy doesn't help that. So this
code is overwriting the fops owner field for ALL active devices, not
just the ones the copy of the template is for....

I'm lost in the maze of this part of DVB (it seems to have some magic
potion to resist me) but I was hoping some of the local citizens could
take a look at this buglet...

Greetings,
    Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org


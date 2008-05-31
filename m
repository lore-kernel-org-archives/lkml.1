Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYEaSje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYEaSje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYEaSj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:39:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:15649 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYEaSj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nk6/QwMOY+Y6VKyaqPMNjIsqlBZiGE3QSFfDXusZnYD8YCmE92GZ+URnr+eKgdstI3mgG45itM8+G7ol4WvxUZVXIpeqYy+pv7MI8y6SEo4d6t0czxo7zLC6Ye4MWq7HVbZdTHkp3DkVQRXDYenKVTcf+qYTEDF+mra4xoI5EO0=
Message-ID: <5a8e970805311139r1355cfccy6933605f7b6441b6@mail.gmail.com>
Date: Sat, 31 May 2008 20:39:25 +0200
From: "Martin Samuelsson" <sam.linux.kernel@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Multiple Zoran MJPEG cards and i2c misattachments
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on avs6eyes improvements in the current kernel. As I've
equipped my machine with no less than three MJPEG-cards; Buz, 6 Eyes
and DC10+, I happened to run into a bit of a snag:

saa7185, the video encoder of the Buz, and bt866, video encoder of the
6 Eyes, share the same i2c address, 0x88. This should not be a
problem, because they are connected to different i2c buses, and are
initialized separately. However, zoran_card.c, via i2c_bit_add_bus(),
creates one i2c bus for each card in the detection loop, and makes
them available system-wide. This means that the saa7185 driver, as the
cards are detected in Buz, 6 Eyes, DC10+ order in my computer, is
being requested by the zoran driver and initializes itself (not very
much to do, as there is not yet any i2c bus). The zoran driver then
creates bus 0, and initializes the saa7185 driver once again, it finds
bus 0 and a chip at 0x88, which it attaches to.

Now, that bus is visible to the system. The 6 Eyes is being
initialized, the bt866 driver loaded, and it initializes itself.
Here's the problem: At load, the drivers automatically searches the
system for available buses. bt866 finds bus 0, belonging to Buz, and a
chip at 0x88, which it promptly attaches to, marking itself as in use.

The zoran driver then creates i2c bus 1, managed by the 6 Eyes, and
initializes the bt866 driver again. It, in turn, looks for i2c buses,
finds bus 0 and address 0x88, notices in i2c_probe_address() that it's
marked as in use, refuses to attach to the chip, proceeds to bus 1 and
the chip at 0x88, notices once again that it's marked as in use, and
refuses to attach to the chip it's supposed to attach to.

The zoran driver has code that determine if a particular chip indeed
is supposed to go with the card it's trying to attach to, but when
i2c_probe_address() says the driver is in use, that code is never
reached.

The 6 Eyes is left with no video encoder and a bt866 driver that think
it's managed to attach successfully, while it in fact is clinging to
the wrong bus.

So far the background...

What would be a working approach to fix this situation? I'm woefully
unaware of the i2c intricacies in the kernel, and know no immediate
fix.

Is it possible to register i2c buses that are not visible to drivers
you modprobe? That would prevent the initial scan of the buses, and
the misattachments. zoran_card.c explicitly initialize the correct
drivers after bus creation anyway.

Is it possible to request_module() a module in a way that will not
make it initialize itself, but just load? The same motivation there,
with the exception that regular modprobes still would mess things up.

Is it possible to detach a wrongly attached driver, while still
technically in i2c_probe(), given only the info in a i2c_driver struct
? That way, zoran_i2c_client_register() in zoran_card.c could gently
rectify the over-optimistic attachments to the wrong buses when
i2c_probe_address() hands over the initialization work to the chip
driver.

Is there an even better way to do this?

/Sam

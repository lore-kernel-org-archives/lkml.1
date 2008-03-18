Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYCRLAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYCRLAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYCRLAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:00:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:15425 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYCRLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pfqXpavRKnyNbzURrajmE7D65zBCG8ByOW9YrcQgGtmep0qjylAEOTMQBd7wCypDJiKBgNJ9YJd9C3ge5yGYzh1HbrhFaC5yWICkHQ/Afaq2nvzDjegMZmuKsR6T+OOTDmpUBQYXU6ra76v3+zrcWKvFSyIGA1iMYoIuqvSAK5Q=
Message-ID: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
Date: Tue, 18 Mar 2008 13:00:34 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: drzeus@drzeus.cx
Subject: SDIO: IO-Ready Bit
Cc: lkml <linux-kernel@vger.kernel.org>, benzizbit@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on SDIO multi function device.  One of the subdevices  a
system device (SYS) who's  purpose among the others is to initialize
the whole combo, mainly it's loads the firmware of the devices and
kick the sub devices. Each of the sub devices has it's own driver.
This dictates the order of the driver initialization and SYS device
has to compete it's work before other subdeivces drivers can access
the hardware. From hardware perspective device is ready when IO-Ready
bit in SDIO is set.
The first problem is that currently there is hard code timeout  in
sdio_enable_func instead of using TPLFE_ENABLE_TIMEOUT_VAL
/*
	 * FIXME: This should timeout based on information in the CIS,
	 * but we don't have card to parse that yet.
	 */
	timeout = jiffies + HZ

This can be probably easily fixed. The significant issue is that this
is done in busy wait loop and that probe functions are called in
serially.

Since we cannot ensure that enumeration of SYS devices will be first
the other sub devices will fail in their probe functions while calling
sido_enable_func

One option is to move the sdio_enable_func to be called from a work
queue kicked from probe. This still requires non-busy wait timeout on
IO-Ready bit and we cannot fail probe func
if something goes wrong.
Second option would be somehow split the sdio probe function across
the enabled timeout.

Thanks
Tomas

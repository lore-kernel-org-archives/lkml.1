Return-Path: <linux-kernel-owner+w=401wt.eu-S936140AbXLQMSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140AbXLQMSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935622AbXLQMS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:18:28 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17307 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754347AbXLQMS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:18:26 -0500
Message-ID: <47666904.8060605@panasas.com>
Date: Mon, 17 Dec 2007 14:18:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Filippos Papadopoulos <psybases@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org> <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
In-Reply-To: <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2007 12:18:14.0871 (UTC) FILETIME=[E6116E70:01C840A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17 2007 at 13:41 +0200, "Filippos Papadopoulos" <psybases@gmail.com> wrote:
> On Dec 17, 2007 1:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Mon, 17 Dec 2007 11:39:47 +0200 "Filippos Papadopoulos" <psybases@gmail.com> wrote:
>>
>>> Hi,
>>> I have got an INITIO 9100 UW SCSI Controller with an IBM
>>> IC35L036UWD210-0 scsi hard disk on a 32 bit x86 system.
>>> Currently i have SUSE 10.1 (Kernel 2.6.16).
>>>
>>> I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
>>> OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
>>> driver
>>> gets loaded during the installation process, yast reports that no hard
>>> disk is found. I believe that this isnt a bug in suse's yast but a
>>> problem
>>> in the initio scsi driver because i also tried to install Fedora 8
>>> (kernel 2.6.23) with the same problem.
>>> I have seen the relevant thread "Conflict when loading initio driver"
>>> and i suppose that the initio driver isnt fixed yet.
>>> I can help testing the new patches in the initio driver if someone is
>>> interested.
>> initio doesn't seem to have a maintainer...
>>
>> Are you able to identify any earlier kernel which worked OK?
>>
> 
> I have this PC configuration since 2002. The initio driver worked
> perfectly with 2.4 kernel series.
> With the release of 2.6 kernel series the driver had been marked as
> BROKEN and fixed at 2.6.9
> (see at http://www.gossamer-threads.com/lists/linux/kernel/482582?search_string=SCSI%20updates%20for%202.6.9;#482582
>   Christoph Hellwig  ->don't mark the initio 9100 driver broken)
> 
> 
>> Maybe it's a new device?  If you can get the `lspci -vvxx' output
>> for that device we can take a look.
>>
> 
> No its not a new device.
> -

I have found one problem. Please try patch [2] below and report.
If it still fails try to enable debugging by setting with patch [1]
these values at top of drivers/scsi/initio.c. And send dmsgs.

Boaz


--------
patch [1]
--------

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 4c4465d..61edcd2 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -138,10 +138,10 @@ static struct pci_device_id i91u_pci_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
 
-#define DEBUG_INTERRUPT 0
-#define DEBUG_QUEUE     0
-#define DEBUG_STATE     0
-#define INT_DISC	0
+#define DEBUG_INTERRUPT 1
+#define DEBUG_QUEUE     1
+#define DEBUG_STATE     1
+#define INT_DISC	1
 
 /*--- forward references ---*/
 static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun);


-----------
patch [2]
-----------
git-diff --stat -p
 drivers/scsi/initio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 4c4465d..61595f6 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2616,6 +2616,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
 			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
 			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+			sg++;
 		}
 
 		cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?



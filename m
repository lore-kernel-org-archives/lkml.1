Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbYIVN5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbYIVN5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYIVN4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:56:51 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62679 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYIVN4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=GXatdSLC74Pq6bu5ZuwGNBbgB4kpCheh3IHVMpb60B9/YBhRaM7HqLe1C7kttKP9m+
         bEdXOdOByY2XXvmvRER+M/D25jXcKQ/Dzc5i0w3y7tksRAfSIp5CdNwQMNEMR+r4HzBr
         D2k7QzNXeqCzg9j8lstwoyFoNiFr/k3CmgiBE=
Message-ID: <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com>
Date: Mon, 22 Sep 2008 15:56:49 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Cc: "Mark de Wever" <koraq@xs4all.nl>, "Gadi Oxman" <gadio@netvision.net.il>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48D79ABD.8060805@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 3:16 PM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Mark de Wever wrote:
>
>> After updating my kernel to 2.6.26 the output for the ide-tape drive
>> during booting is garbled eg
>> ide-tape: hdd <-> ht0: Seagate <98>ß8A51|1À<81>Üº<98>ß STT20000A rev
>> 8A51|1À<81>Üº<98>ß
>
>> This patch fixes the problem by NULL terminating the strings.
>
>   Looks like this bugs was introduced by this commit:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=41f81d545b6b1f585a02d1d8545978714f710e91

.. and I know why :). Those ide_tape_obj members (char fw_rev[6], vendor_id[10],
product_id[18]) were used only once in idetape_get_inquiry_results() so I moved
them there as local stack variables. Originally, they were kzalloc'ed as part of
struct ide_tape_obj and now they contain stack garbage therefore the funny
values. The simple solution would be to zero them out or:


Does the following patch help?

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1bce84b..848d9df 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2338,7 +2338,7 @@ static void
idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	char fw_rev[6], vendor_id[10], product_id[18];
+	static char fw_rev[6], vendor_id[10], product_id[18];

 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {


-- 
Regards/Gruss,
Boris

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYIVNYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYIVNYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYIVNYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:24:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:10969 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933AbYIVNYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:24:43 -0400
Message-ID: <48D79CD5.5000605@ru.mvista.com>
Date: Mon, 22 Sep 2008 17:25:41 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 06/22] ide-tape: struct idetape_tape_t: remove unused
 members
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <1202132440-26648-7-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202132440-26648-7-git-send-email-petkovbb@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

> - last_frame_position: only being written to once
> - firmware_revision, product_id, vendor_id: used once, remove from struct
>   idetape_tape_t and deal with them locally
> - firmware_revision_num: only written to once
> - tape_still_time_begin: completely unused
> - tape_still_time: never written to; remove corresponding code chunk
> - uncontrolled_last_pipeline_head: only once written to
> - blocks_in_buffer: only written to

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

    Late complaint but anyway... :-)

> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index e0e8184..126e8a9 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -399,11 +397,6 @@ typedef struct ide_tape_obj {
>  	int avg_size;
>  	int avg_speed;
>  
> -	char vendor_id[10];
> -	char product_id[18];
> -	char firmware_revision[6];
> -	int firmware_revision_num;
> -
>  	/* the door is currently locked */
>  	int door_locked;
>  	/* the tape hardware is write protected */

[...]

> @@ -3438,9 +3419,9 @@ static int idetape_identify_device (ide_drive_t *drive)
>  
>  static void idetape_get_inquiry_results(ide_drive_t *drive)
>  {
> -	char *r;
>  	idetape_tape_t *tape = drive->driver_data;
>  	idetape_pc_t pc;
> +	char fw_rev[6], vendor_id[10], product_id[18];
>  
>  	idetape_create_inquiry_cmd(&pc);
>  	if (idetape_queue_pc_tail(drive, &pc)) {
> @@ -3448,20 +3429,16 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>  				tape->name);
>  		return;
>  	}
> -	memcpy(tape->vendor_id, &pc.buffer[8], 8);
> -	memcpy(tape->product_id, &pc.buffer[16], 16);
> -	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
> -
> -	ide_fixstring(tape->vendor_id, 10, 0);
> -	ide_fixstring(tape->product_id, 18, 0);
> -	ide_fixstring(tape->firmware_revision, 6, 0);
> -	r = tape->firmware_revision;
> -	if (*(r + 1) == '.')
> -		tape->firmware_revision_num = (*r - '0') * 100 +
> -			(*(r + 2) - '0') * 10 +	*(r + 3) - '0';
> +	memcpy(vendor_id, &pc.buffer[8], 8);
> +	memcpy(product_id, &pc.buffer[16], 16);
> +	memcpy(fw_rev, &pc.buffer[32], 4);
> +
> +	ide_fixstring(vendor_id, 10, 0);
> +	ide_fixstring(product_id, 18, 0);
> +	ide_fixstring(fw_rev, 6, 0);

    It was wrong to call ide_fixstring() on unterminated strings and expecting 
them to become terminated strings after that; plus it was useless to add 2 
characters padding at the end. When these variables were the fields of 'struct 
ide_tape_obj', those bytes were 0 because of the variable of this type being a 
static array. When they became local variables, they got garbage bytes at the 
end which ide_fixdriveid() either honestly copied when compressing spaces or 
just left where they were...

> +
>  	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",

    Should've rather changed the string format to print only N characters max...

MBR, Sergei

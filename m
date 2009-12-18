Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZLRX5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZLRX5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZLRX5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:57:35 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59037 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZLRX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:57:33 -0500
Message-ID: <4B2C15D5.9040501@gawab.com>
Date: Fri, 18 Dec 2009 15:52:53 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091215 Shredder/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, error27@gmail.com,
       ray-lk@madrabbit.org
Subject: Re: [PATCH] staging: s5k3e2fx.c: simplify complexity by factoring
References: <1260910330-3409-1-git-send-email-jdm64@gawab.com> <20091218184146.GE2909@kroah.com>
In-Reply-To: <20091218184146.GE2909@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 10:41 AM, Greg KH wrote:

> On Tue, Dec 15, 2009 at 12:52:10PM -0800, Justin Madru wrote:
>> the code was looping, seting s_move[i] to the following calculations
>>
>> if (actual_step>= 0)
>>          s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
>> else
>>          s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);
>>
>> but, this code redues to the expression
>> 	s_move[i] = gain>>  10;
>>
>> The reason for the complexity was to generate a step function with
>> integer division and rounding to land on specific values. But these calculations
>> can be simplified to the following code:
>>
>> 	gain = ((actual_step<<  10) / 5)>>  10;
>> 	for (i = 0; i<= 4; i++)
>> 		s_move[i] = gain;
>
> Care to resend this with a Signed-off-by: line, and add the reviewed-by
> line that was requested by Ray?
>
> thanks,
>
> greg k-h
Sorry about that, new at submitting patches, don't completely know the flow yet.
Does the below format work for you? Hopefully my email client won't mess the patch up.

Justin Madru
------

From: Justin Madru<jdm64@gawab.com>
Date: Tue, 15 Dec 2009 12:27:31 -0800
Subject: [PATCH] staging: s5k3e2fx.c: simplify complexity by factoring

the code was looping, setting s_move[i] to the following calculations

if (actual_step>= 0)
         s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
else
         s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);

but, this code reduces to the expression
	s_move[i] = gain>>  10;

The reason for the complexity was to generate a step function with
integer division and rounding to land on specific values. But these calculations
can be simplified to the following code:

	gain = ((actual_step<<  10) / 5)>>  10;
	for (i = 0; i<= 4; i++)
		s_move[i] = gain;

Signed-off-by: Justin Madru<jdm64@gawab.com>
Reviewed-by: Ray Lee<ray-lk@madrabbit.org>
---
  drivers/staging/dream/camera/s5k3e2fx.c |   10 +++-------
  1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index f0e49be..93162a0 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -1092,14 +1092,10 @@ static int32_t s5k3e2fx_move_focus(int direction, int32_t num_steps)

  	actual_step = step_direction * (int16_t)num_steps;
  	pos_offset = init_code + s5k3e2fx_ctrl->curr_lens_pos;
-	gain = actual_step * 0x400 / 5;
+	gain = ((actual_step<<  10) / 5)>>  10;

-	for (i = 0; i<= 4; i++) {
-		if (actual_step>= 0)
-			s_move[i] = ((((i+1)*gain+0x200) - (i*gain+0x200))/0x400);
-		else
-			s_move[i] = ((((i+1)*gain-0x200) - (i*gain-0x200))/0x400);
-	}
+	for (i = 0; i<= 4; i++)
+		s_move[i] = gain;

  	/* Ring Damping Code */
  	for (i = 0; i<= 4; i++) {
-- 
1.6.5.6



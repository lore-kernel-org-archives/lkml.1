Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbZLOTLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbZLOTLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbZLOTLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:11:11 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:39657 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbZLOTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=YT2C6hJRbfduSqi/YyUaalyXPOa3I+swuckPHTYbmQiver1xadiY9RmuJk0JbDwuB4
         fZe3iaHOqp86XWGhbc9131z4SZfJ5YP6N3Pyx/4HYyYha8HEHLTzeeaceUfW6t2WgC9w
         Pcf45jEveXnWBroMM8eE/aphs5l2SXjPLOknk=
MIME-Version: 1.0
In-Reply-To: <4B27D756.4050102@gawab.com>
References: <1260065000-5573-1-git-send-email-jdm64@gawab.com> 
	<2c0942db0912142002p638a187araa837812862e5b17@mail.gmail.com> 
	<4B27D756.4050102@gawab.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 15 Dec 2009 11:10:47 -0800
X-Google-Sender-Auth: e00e04f9b836338f
Message-ID: <2c0942db0912151110n28f339a7m53d276044623adef@mail.gmail.com>
Subject: Re: [PATCH] staging: s5k3e2fx.c: reduce complexity by factoring
To: Justin Madru <jdm64@gawab.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:37 AM, Justin Madru <jdm64@gawab.com> wrote:
> But, wouldn't you agree that if the code was suppose to deal with "rounding
> issues" that there's a
> simpler expression?

No, I don't agree. Five minutes of effort below shows your patch will
generate different numbers than the original. If this is controlling a
stepper motor trying to hit a home position, it's off now. Or, the
errors in the expressions for moving near and far may have balanced
each other out before, and now there may be a systematic error causing
a skew over time toward one end rather than the other.

My point is that you need to run this past the guy with the actual
hardware who wrote it in the first place such that it can be tested,
and make sure the slapped-together expression isn't just working by
accident, as ugly as it might be.

#include <stdio.h>

typedef int int32_t;
typedef short int16_t;
typedef unsigned int uint32_t;

enum {MOVE_NEAR, MOVE_FAR} move_direction;

int32_t s5k3e2fx_move_focus(int direction, int32_t num_steps)
{
        int32_t i;
        int16_t step_direction;
        int16_t actual_step;
        int16_t s_move[5], s_move_2[5];
        uint32_t gain, gain_2;

        if (direction == MOVE_NEAR)
                step_direction = 20;
        else
                step_direction = -20;

        actual_step = step_direction * (int16_t)num_steps;

        gain = actual_step * 0x400 / 5;
	gain_2 = actual_step / 5;
	
        for (i = 0; i <= 4; i++) {
                if (actual_step >= 0)
                        s_move[i] = ((((i+1)*gain+0x200) -
(i*gain+0x200))/0x400);
                else
                        s_move[i] = ((((i+1)*gain-0x200) -
(i*gain-0x200))/0x400);
        }

        for (i = 0; i <= 4; i++)
                s_move_2[i] = gain_2;

	if (memcmp(s_move, s_move_2, sizeof(s_move))) {
		printf("s1, s2 differ for direction %d, num_steps %d\n", direction,
num_steps);
		for (i=0; i<5; i++)
			printf(" [%d] %d %d", i, s_move[i], s_move_2[i]);
		printf("\n");
	}

}

int main(void) {
	int steps;
	for (steps = -65535; steps < 65536; steps++) {
		s5k3e2fx_move_focus(MOVE_NEAR, steps);
		s5k3e2fx_move_focus(MOVE_FAR, steps);
	}
}



>
> Justin
>

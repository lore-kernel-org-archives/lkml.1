Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYKHKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYKHKBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 05:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYKHKBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 05:01:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:59182 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751748AbYKHKBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:01:07 -0500
X-Authenticated: #36613700
X-Provags-ID: V01U2FsdGVkX18LZ8k/gX4Li3FfzAHTD0F4ZPTtHChTESW/9anDgF
	gCMyBYGXNx8/QW
From: Mathias Schnarrenberger <mathias.schnarrenberger@gmx.de>
Reply-To: mathias.schnarrenberger@gmx.de
To: linux-kernel@vger.kernel.org
Subject: security: delete BIOS password in keyboard buffer during kernel bootup
Date: Sat, 8 Nov 2008 11:00:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811081100.03966.mathias.schnarrenberger@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using a BIOS password in my notebook (nc6120 from HP). Recently I noticed that the HP BIOS doesn't clean the keyboard buffer after the password was correctly entered. I know that this is rather a BIOS thing but I assume that other BIOSes also don't clean the BIOS keyboard ring buffer (at adress from 0x0000041E up to 0x0000043D). Since after the kernel boot up the BIOS Keyboard ISR is deactivated no one cares about the data in the keyboard buffer. So, the BIOS password is kept in the buffer.

So, I think it would be good if the kernel clears the keyboard buffer during boot up (at least in x86-based systems) to protect the users password. I don't know anything about EFI-based systems and other architectures.
Because I'm not sure where to implement the code to delete the keyboard buffer in the kernel, I can't make a proper patch. Possibly one of you can do this ;)


To read the BIOS keyboard buffer this piece of code can be used:

#include <stdio.h>
#include <string.h>
int main(void) {
  FILE *file;
  int i;
  char keybuffer[32];

  file = fopen("/dev/mem","r");

  if (file==NULL) {
    printf("Couldn't open file\n");
    return 0;
  }
  //set pointer to keyboard buffer
  fseek(file, 0x41E, SEEK_SET);
  //get ASCII / scancodes
  for (i=0;i<32;i++)
    keybuffer[i] = fgetc(file);

  fclose(file);

  for (i=0;i<32;i++)
    printf("position in buffer: %i \t value %i \t character %c\n",i,(int)keybuffer[i],keybuffer[i]);

  return 0;
}


I hope I didn't waste too much of your time.

Best regards,
Mathias Schnarrenberger

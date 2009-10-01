Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZJAUeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZJAUeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZJAUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:34:15 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:52215 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbZJAUeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:34:14 -0400
Message-ID: <4AC51244.1010600@linux.vnet.ibm.com>
Date: Thu, 01 Oct 2009 17:34:12 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jsm: fixing termios structure to be compatible with stty
 application
References: <1254327512-6880-1-git-send-email-leitao@linux.vnet.ibm.com> <20090930213140.4172748f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090930213140.4172748f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> NAK
> 
> termios->c_ispeed/ospeed are the actual baud rates not bit encodings
Well, c_flag & CBAUD is the baud rate encoded in the Bfoo format. 

> Use
> 
> 	tty_termios_encode_baudrate(termios, ispeed, ospeed);

Well, let me explain you what I want to do. 
Actually stty.c source code do: 

	tcsetattr (STDIN_FILENO, TCSADRAIN, &mode)
	tcgetattr (STDIN_FILENO, &new_mode)
	...
	if (memcmp (&mode, &new_mode, sizeof (mode)) != 0)
		 error (EXIT_FAILURE, 0,....)

When I run stty -F /dev/ttyn0 speed 9600, the mode structure is different
from new_mode, causing that error.
Debugging those structure, I found that ispeed and ospeed were not set in the
Bfoo format, as expected, since mode->[o|i]speed are set in Bfoo format.

Hence, I just assigned ospeed and ispeed with the requested speed in Bfoo
format (c_flag & CBAUD).

I also tested the tty_termios_encode_baud_rate(), and it will basically do what
I did:

        termios->c_ispeed = ibaud;
        termios->c_ospeed = obaud;

Thanks for the review, and sorry if I missed the point completely.
Breno

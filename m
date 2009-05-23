Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZEWQ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZEWQ1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZEWQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:27:00 -0400
Received: from web1112.biz.mail.sk1.yahoo.com ([74.6.114.44]:45335 "HELO
	web1112.biz.mail.sk1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752656AbZEWQ07 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:26:59 -0400
Message-ID: <60483.14588.qm@web1112.biz.mail.sk1.yahoo.com>
X-YMail-OSG: P1eaNlwVM1n9XBhet5YxHdR80s.TmLMsQ.ntT4LGlJoI_jx6iyw.ftJiprbJqpq_oC_RRV1MVKEjQ_gk86zDWsqgSAlF_q5s_1.tssYh0raH68ZYoRauQB88AYmCAYOKw0g382MbNQy6mWvgKLpvEFxoNLNz8ccVOKmM6QIHH9_T98ZmKQW.PbMUCLEYkrYmJsBQjKNNbmHi0gXwecWmNZFRDL_0yIVDBhDq2IgKr9QA8VG8GMgujLQrdvrKG9nbcWDBeoVOhE33iQ--
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.10
Date: Sat, 23 May 2009 09:27:00 -0700 (PDT)
From: Richard Schmitt <rschmitt@bluepeach.com>
Subject: Re: TTY/Serial Driver Hangs in tty_wait_until_sent, analysis, and recommendations
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



There is a catch 22 with the linux serial driver architecture that can hang apps and can hang shells.  I can reproduce this at will on our powerpc 8313 system with a 8250 uart driver. 

The problem happens because we can output a lot of text on the console at high speed.  This will overrun the receiver which may send XOFF’s.  Because of the high speed and slow response of the serial port, the linux system does not process the XOFF right away.  Instead, the receiver keeps sendings XOFFs and BELLS to complain that it is dropping data.  There is so much data coming back from the receiver, that eventually the console’s input buffer becomes full.  Because the input buffer is full, the linux system is unable to receive a subsequent XON from the receiver. 

Now in a normal situation this would clear up because the input buffer would get processed but when bash is the program that will read the input buffer,  it may be busy trying to modify the terminal modes.  The bash shell manipulates the terminal settings very often.  When manipulating the settings, it makes a system call that waits for the terminal output buffer to be empty.  Well, since the terminal server has the console in flow control, the buffer is not going to drain right away and since the shell is waiting for the termio to complete it won’t get around to calling a read from the serial port which it needs to do in order for the serial driver to free up some input room for receiving new characters.  Only upon receiving new characters, will it detect an XON and allow the output buffer to drain.

So, the console is hung.  Control C characters and Control Q characters are not processed and there is nothing you can do short of logging on through a different port and killing the shell on the console.

We do things that compound the situation for ourselves.  One, we send lots of stuff to the console port especially when we are in debug mode.  Second, we run our serial ports at very high baud rates.  Third, our networks are incredibly congested and cause the terminal servers to back up.  Fourth, we use our console as a shell. 

I think there are two long term solutions to this: 1) have the low level serial port drivers (i.e. 8250) treat XON/XOFF out of band and have some back door into the line discipline driver to restart the serial line without needing input buffer space and 2) to change the tty_ioctl handling of a WAIT call to flush the output buffer if the port is stopped.  I figure either of these approaches alters the serial behavior enough that it is more then just a bug fix.

Our workaround is to not allow bash to run on the console, but although that will keep us from seeing the problem, it is something others may see and should know about.

Some data points we saw with gdb:

The console was in a ‘stopped’ state waiting for an XON.
The console had data to send
The console had no room to receive additional characters from the terminal server
Bash was waiting for the output buffer to drain and is blocked inside of tty_wait_until_sent
No one was doing a read on the console port.
The input buffer was filled with BELLs (^Gs)

I’ve searched the various discussion lists and although I’ve seen that folks have seen port hangs with a shell stuck in tty_wait_until_sent, I haven’t seen this analysis described nor any resolution to the problem.  I’ve decided to post this here in the event that a) someone knows of a real fix b) the analysis is new and piques someone’s interest to resolve it, c) the analysis can provide insight to others as to how to work around the problem if they see it.

I’m not on the kernel mailing list.  If you wish to respond, please include my email explicitly.

Rich

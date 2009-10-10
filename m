Return-Path: <linux-kernel-owner+w=401wt.eu-S1762097AbZJJUZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbZJJUZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbZJJUZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:25:46 -0400
Received: from smtp109.mail.ukl.yahoo.com ([77.238.184.32]:20735 "HELO
	smtp109.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756751AbZJJUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:25:46 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 16:25:45 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=tepZJo6FxC7Khp6WRr0xVw2BlEGZqZgwCRIj36ubG5hhXhufZqTE8DMK789ZKNCXj269XCDffni96K89COB6hVpO9vh8CL+6YVJi3mUXB1rNamVmm1pv+A9gJRH3N/pXWqYzuaXQcqLyWjkOXgoy4GTHgwL2dREJ6i9HpeIiYMg=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: 268sBNUVM1nQ.Z1ZI0kZN5nF47kFs6ewQ_0o_tnB5t4_y51amXqiJAdWwWtC6MHyyROjGLfiVjOml3gWp0iwzR3V4wDmc_0qoQ_tphBbWamB.ycjarwQjyhpGYple7mgYFf__DIPYWwZhYtjyPOxyDGizHCD4MBoljtdRYwtBjf3iMw9Rj9B3_m0yfXYXOsbLGChvDE25jlQG4SvQkscZr9F7QoNjoIa8erx0TrDp60QuGaMy0sdh_sLYs4lvm9J1Wx8g.yuFKsRcgDNM7.U.v2hozRNCbwAnfVR_Qn8ZxSs8jlnQuMbGPNISZvkYrh9SNLdP7CJ1Hicxmvrj5Y-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AD0EC21.6060204@yahoo.co.uk>
Date: Sat, 10 Oct 2009 23:18:41 +0300
From: Boyan <btanastasov@yahoo.co.uk>
Reply-To: alpine.LNX.2.01.0910071706490.11297@dyndns.pervalidus.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hirofumi@mail.parknet.co.jp, alan@linux.intel.com
Subject: Re: keyboard under X with 2.6.31
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 17:19:25 -0300, Frédéric L. W. Meunier wrote:
> My keyboard (ABNT2 PS/2) seems to be broken under X with 2.6.31.2.
> After less than an hour, it starts acting crazy. The first time, all
> leds turned off and I couldn't type anything. The second time, all
> leds > also turned off, but since it happened while I was pressing the
> Backspace key to delete text, it continued deleting, like if the key
> was pressed.
>
> In both cases, the mouse (USB) still works and I can exit X, where the
> keyboard works. There's nothing in the logs.
>
> No problem with 2.6.30.9. Is it supposed to be a kernel or X bug ?

Something similar is happening with my keyboard too. With 2.6.31 after
some time the keyboard stops under X on my Fedora 11. I can switch to
text console only after SysRq+R. When go back to X the keyboard is
working, but after some time it stops again. 


I can trigger it easily with gthumb quickly changing pictures, but it is
possible with other cpu intensive operations too. To be sure I've tested
with previous X 1.6.3-4 which was from August and I've used it without
problems with 2.6.30 and 2.6.30.3. It was replaced on 18 Sep 2009 by
1.6.4 RC (installed update after 2.6.31). The problem is reproducible on
both of X versions with 2.6.31, 2.6.31.3 and 2.6.32-rc3.

I've bisected this and the result is:

e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 is first bad commit
commit e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
Author: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date:   Wed Jul 29 12:15:56 2009 -0700

     pty: avoid forcing 'low_latency' tty flag

     We really don't want to mark the pty as a low-latency device, 
because as
     Alan points out, the ->write method can be called from an IRQ (ppp?),
     and that means we can't use ->low_latency=1 as we take mutexes in the
     low_latency case.

     So rather than using low_latency to force the written data to be pushed
     to the ldisc handling at 'write()' time, just make the reader side (or
     the poll function) do the flush when it checks whether there is data to
     be had.

     This also fixes the problem with lost data in an emacs compile buffer
     (bugzilla 13815), and we can thus revert the low_latency pty hack
     (commit 3a54297478e6578f96fd54bf4daa1751130aca86: "pty: quickfix 
for the
     pty ENXIO timing problems").

     Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
     Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
     [ Modified to do the tty_flush_to_ldisc() inside input_available_p() so
       that it triggers for both read and poll()  - Linus]
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 52e7420b2aa2360632dd965e56b96510619d34e2 
5156b59352d1350cb9b4d452581dd84d24d5a541 M      drivers
:040000 040000 f0a333b7faa0ce80a57e2ee8536e79a6fe33ac35 
b3968b239ac3f64c57f17bb10034b98559f1ffa2 M      include


Reverting this patch on top of 2.6.31.3 fixes it for me.

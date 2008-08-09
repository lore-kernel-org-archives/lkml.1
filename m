Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbYHIBYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbYHIBYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYHIBXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:23:53 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:21798 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752842AbYHIBXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:23:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=BKDGUc8OxED3CS2iVchVA049NHlufPfeu19Ih78yA8PUVkfvczNFYHVhos/J5DM6Z0xziPuKcP5OcXDCZ9hLJu7H8z2IWkpwgmkFd9ZsQlK+8RuPW+gLV4JLFqIYKlnFrSPGhthi7CAZ2h8IHpNGml9Yzi+/YvIlRQUs8eis7H4=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 8 Aug 2008 18:23:52 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <506429.22669.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tracked the regression down to an RCU problem.

I added some printk()'s to the function inet_register_protosw() in
net/ipv4/af_inet.c, as seen in this diff:

===== BEGIN DIFF ==========
      * non-permanent entry.  This means that when we remove this entry, the
      * system automatically returns to the old behavior.
      */
+    printk ("     Adding new protocol\n");
     list_add_rcu(&p->list, last_perm);
+
 out:
+    printk ("     Unlocking spinlock\n");
     spin_unlock_bh(&inetsw_lock);
 
+    printk ("     Calling synchronize_net()\n");
     synchronize_net();
 
     return;
===== END DIFF ==========

A kernel built with these changes freezes with "Calling synchronize_net()"
as the last printed line.

I located the function synchronize_net() in net/core/dev.c, and it was easy
to add some printk()'s there:

===== BEGIN DIFF ==========
 
void synchronize_net(void)
 {
+    printk ("   synchronize_net(): calling might_sleep()\n");
     might_sleep();
+
+    printk ("   synchronize_net(): calling synchronize_rcu()\n");
     synchronize_rcu();
 }
===== END DIFF ==========

The kernel built with these changes froze with "synchronize_net(): 
calling synchronize_rcu()" as the last line on the screen.

After reading some documentation in Documentation/RCU/, it looks like 
something is misusing RCU -- and, according to the Documentation, those kinds 
of mistakes are easy to make.  Maybe necessary calls to
 
    rcu_read_lock()
    rcu_read_unlock()

are missing, and something about my hardware is triggering a freeze that 
doesn't occur on most hardware.


For some reason, turning off the HPET by booting with "hpet=disabled" keeps
the freeze from happening.  Just reading a couple of those docs about RCU
made me dizzy, so I hope someone familiar with RCU issues will take a look
at the code in the files I've listed.  Surely you guys can take it from here
now?!

If not, just give me some experimental code changes to make to get my 2.6.26
and 2.6.27 kernels working again without disabling HPET!!!


Thanks,
Dave Witbrodt

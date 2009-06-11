Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbZFKXEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbZFKXEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZFKXEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:04:32 -0400
Received: from web83816.mail.sp1.yahoo.com ([69.147.85.95]:38938 "HELO
	web83816.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757511AbZFKXEb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:04:31 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 19:04:31 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ahkI7b2h3jwnFvmLxd/hmdW9JeS9xHinHinHt4dpcY5sr93jBYlbQskrO5PeMc8lgKR4EOD2vHBO2FBWb5gcAoPh7/40g5Mody+ZTJ+BXPLnJc6BkgEgAgUhRasgAV+E0tn48D0gAeXhTMRZOI67y9eOHG3gONpJvwNk+SBpOcI=;
Message-ID: <38569.31214.qm@web83816.mail.sp1.yahoo.com>
X-YMail-OSG: mtPRfQQVM1kls8wQeCgw6gJzNmHjAqF2eA6f1NVTOrqrtCurk1U5KbTg0Nq0IZYR18w9oHBjZiPipH2_I8kQPJwvTlD6RyP15zlYBk6aRjsf8eTHnz53QWnivXq7Ym2Siy3q0K1JDmsmSlYR.0pw_mslYp2soRK5qVEpgQ6XViNEzky0knwRKmOYYChg5c9Pzv241fPVsnrwRvZtgf9zIGuv1vJO3PZVnllBh..EvwaSoYDwqnqOMX7coUlzktkp.1uiqmvyeFCIVLXpPgvMpg9dg.4XTf2sSk3jBDMVn00uvQcAcTKMdxZly1pbY3lGFnZ_cw--
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
Date: Thu, 11 Jun 2009 15:57:52 -0700 (PDT)
From: James Huang <jamesclhuang@yahoo.com>
Subject: real-time preemption and RCU
To: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Paul,
 
        I have read through your year 2005 document on real-time preemption and RCU.
It was very interesting and your approach to the problem (by gradual improvement in each new implementation) make the idea very clear.
However, I am baffled by the following potential race condition that exists in implementation 2 through 5.
To keep the case simple, let's choose implementation 2 to illustrate:
 
 
CPU0           |<-- delete M1 -->|             ||           |<---- delete M2 --->|        <------  delete M3 ---->|
                                                          || 
                                                          ||
CPU1      |<-----   read M1--------->|         ||    |<-------------------------    read M2  --------------------------------------->|
                                                          ||     
                                                          ||
CPU2                                             time T: execute synchronize_kernel: rcu_ctrlblk.batch++                

Assume initially 

rcu_data[cpu0].batch = 1
rcu_data[cpu1].batch = 1
rcu_data[cpu2].batch = 1
rcu_ctrlblk.batch = 1

The following steps are executed:
(1)  cpu1 read-locked rcu_ctrlblk.lock, read M1, read-unlocked rcu_ctrlblk.lock
(2)  cpu0 deleted M1
(3)  At time T (marked by || ), cpu2 executed synchronize_kernel: write-locked rcu_ctrlblk.lock, incremented rcu_ctrlblk.batch to 2, and write-unlocked rcu_ctrlblk.lock
(4) cpu1 read-locked rcu_ctrlblk.lock, spent a long time in its rcu read-side critical section, read M2, read-unlocked rcu_ctrlblk.lock
(5) cpu0 deleted M2.  But when it executed run_rcu(), cpu0 DID NOT see the most up-to-date value of rcu_ctrlblk.batch.
     So cpu0 just inserted M2 into cpu0's waitlist, but did not free up M1 and did not update rcu_data[cpu0].batch (i.e. it was still equal to 1).
(6) cpu0 deleted M3. At this time cpu0 saw the most up-to-date value of rcu_ctrlblk.batch (2).
     Since rcu_ctrlblk.batch (2) is larger than rcu_data[cpu0].batch (1), cpu0 freed up memory blocks in its waitlist.
     So both M1 and M2 were freed up by cpu0.  But if cpu1 was still accessing M2, this will be a problem.

Am I missing something here?  Does the smp_mb() within run_do_my_batch() has anything to do with this issue?


-- James Huang


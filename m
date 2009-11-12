Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZKLXwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZKLXwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZKLXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:52:40 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57835 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZKLXwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=AUP1fgZsj3poCHgRJl1s7qzqmbEIDrk7rvv6LpPuli3ap4lrGHWOg15hmo8JNOMI+7
         lhpo+3RfDLm5u85ASLlvTywUnvyowAOyoV2kBXBfE14wucrAI9VLlJSUibjSQuQ0XTGx
         Bh6l+owTzvqgumNB9BCxmFddfRweT6jX/sDKA=
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 15:52:43 -0800
X-Google-Sender-Auth: 91adc41523558126
Message-ID: <a27c0c970911121552w63f63baew93d06336b39816a5@mail.gmail.com>
Subject: RT wakeup woes in Linux 2.6.31.6 on Mac Mini
From: Greg Steuck <greg@nest.cx>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel gurus,

I would appreciate some ideas about reducing wakeup latency for our
real time application. The write up below identifies 3 seemingly
different cases of our task not getting to run long after it is woken
up.

We have a real-timish requirement for feeding a hardware device on
time. To achieve this goal we run a userspace program with SCHED_FIFO
at priority 99. We also set CPU affinity with sys_sched_setaffinity
inside our driver program (rxtest) to get a dedicated core (#1). We
change the affinity of all user processes (i.e. non-kernel threads) on
the system to stay on the other core (#0). Then we ran a bunch of
experiments with wakeup ftrace tracer enabled. Here is the script we
ran:

sudo mount -t debugfs nodev /sys/kernel/debug
cd /sys/kernel/debug/tracing

while : ; do
  sudo sh -c '
      echo wakeup > current_tracer
      echo 0 > tracing_max_latency
      echo 2 > tracing_cpumask
      echo 1 > tracing_enabled
      chrt -f 99 ~/rxtest -logtostderr 2>&1
      echo 0 > tracing_enabled
      cat trace > ~/trace.$$'
done | tee ~/tracing-wakeup-latency

There was some decent disk activity to keep the machine busy while the
script was running (rsync copying kernel source directory). We ran the
experiment some 15000 times and observed the average wakeup latency of
about 276 microseconds. There are however a few outliers that would be
nice to understand.

 Latency (us)	Trace log file
 612	trace.1029
 900	trace.13653
 922	trace.6039

The attachments at http://sites.google.com/a/nest.cx/public/rtwakeup
have machine configuration and full traces. Belows are excerpts from
the trace files:

% egrep '[+!]' trace.*
trace.1029:  <idle>-0       1d.s.    0us :      0:140:R   + [001]
1030:  0:S rxtest
trace.1029:  <idle>-0       1.Nh.   80us+: mii_rw <-nv_update_linkspeed
trace.1029:  <idle>-0       1.Nh.   85us+: delay_tsc <-__delay
trace.1029:  <idle>-0       1.Nh.   97us+: delay_tsc <-__delay
trace.1029:  <idle>-0       1.Nh.  109us+: delay_tsc <-__delay
trace.1029:  <idle>-0       1.Nh.  120us+: delay_tsc <-__delay
...
trace.13653:kblockd/-65      1d.s.    0us :     65:115:R   + [001]
13654:  0:S rxtest
trace.13653:kblockd/-65      1dN..  130us+: kmem_cache_alloc
<-mempool_alloc_slab
trace.13653:kblockd/-65      1dN..  132us+: blk_rq_map_sg <-scsi_init_sgtable
trace.13653:kblockd/-65      1dN..  200us+: blk_rq_map_sg <-scsi_init_sgtable
trace.13653:kblockd/-65      1dN..  264us+: ata_tf_to_fis <-ahci_qc_prep
trace.13653:kblockd/-65      1dN..  289us+: blk_rq_map_sg <-scsi_init_sgtable
trace.13653:kblockd/-65      1dN..  349us+: ata_tf_to_fis <-ahci_qc_prep
...
trace.6039: pdflush-5162    1d.s.    0us :   5162:120:R   + [001]
6040:  0:S rxtest
trace.6039: pdflush-5162    1dN..   61us+: idle_cpu <-irq_exit
trace.6039: pdflush-5162    1dN..  130us!: idle_cpu <-irq_exit
trace.6039: pdflush-5162    1dN..  273us!: idle_cpu <-irq_exit

Thanks
Greg
-- 
nest.cx is Gmail hosted, use PGP for anything private. Key:
http://tinyurl.com/ho8qg
Fingerprint: 5E2B 2D0E 1E03 2046 BEC3  4D50 0B15 42BD 8DF5 A1B0

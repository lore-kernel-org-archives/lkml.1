Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0BSTsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:48:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:41977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0BSTsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:48:07 -0500
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 20:47:55 +0100
Message-ID: <1266608875.1529.749.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 10:36 -0800, Suresh Siddha wrote:
> exec/fork balance is not broken. i.e., during exec/fork we balance the
> load equally among sockets/cores etc. What is broken is:
> 
> a) In SMT case, once we end up in a situation where both the threads of
> the core are busy , with another core completely idle, load balance is
> not moving one of the threads to the idle core. This unbalanced
> situation can happen because of a previous wake-up decision and/or
> threads on other core went to sleep/died etc. Once we end up in this
> unbalanced situation, we continue in that state with out fixing it.
> 
> b) Similar to "a", this is MC case where we end up four cores busy in
> one socket with other 4 cores in another socket completely idle. And
> this is the situation which we are trying to solve in this patch.
> 
> In your above example, we test mostly fork/exec balance but not the
> above sleep/wakeup scenarios. 

Ah, indeed. Let me extend my script to cover that.

The below script does indeed show a change, but the result still isn't
perfect, when I do ./show-loop 8, it starts 8 loops nicely spread over 2
sockets, the difference is that all 4 remaining would stay on socket 0,
the patched kernel gets 1 over to socket 1.


---

NR=$1; shift

cleanup()
{
  killall loop
}

show_each_loop()
{
  KILL=$1

  ps -deo pid,sgi_p,cmd | grep loop | grep bash | while read pid cpu cmd; do

    SOCKET=`cat /sys/devices/system/cpu/cpu${cpu}/topology/physical_package_id`
    CORE=`cat /sys/devices/system/cpu/cpu${cpu}/topology/core_id`
    SIBLINGS=`cat /sys/devices/system/cpu/cpu${cpu}/topology/thread_siblings_list`

    printf "loop-%05d on CPU: %02d SOCKET: %02d CORE: %02d THREADS: ${SIBLINGS} " $pid $cpu $SOCKET $CORE

    if [ $SOCKET -eq $KILL ]; then 
      kill $pid;
      printf "(killed)"
    fi

    printf "\n"
  done
}

trap cleanup SIGINT

echo "starting loops..."

for ((i=0; i<NR; i++)) ; do
  ./loop &
done

sleep 1;

echo "killing those on socket 1..."
echo ""

show_each_loop 1

echo ""
echo "watching load-balance work..."
echo ""

while sleep 1 ; do 

   show_each_loop -1 | sort | awk '{socket[$6]++; th[$8 + (256*$6)]++; print $0} 
	    END { for (i in socket) { print "socket-" i ": " socket[i]; } 
		  for (i in th) { if (th[i] > 1) { print "thread-" int(i/256)"/"(i%256) ": " th[i]; } } }'

  echo ""
  echo "-------------------"
  echo ""

done




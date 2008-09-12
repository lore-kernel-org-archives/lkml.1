Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYILHF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYILHF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 03:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYILHFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 03:05:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:39169 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750704AbYILHFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 03:05:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PGfAVexUPndg2bl7MfdBPqPcET0yLDnwlM5q3ZE
	7aiMAvRJyGuMGO
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
	one task
From: Mike Galbraith <efault@gmx.de>
To: ego@in.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20080912063539.GB4872@in.ibm.com>
References: <20080905123004.GD6238@in.ibm.com>
	 <1220627628.11202.16.camel@twins.programming.kicks-ass.net>
	 <1220635424.11202.20.camel@twins.programming.kicks-ass.net>
	 <20080912063539.GB4872@in.ibm.com>
Content-Type: multipart/mixed; boundary="=-5W1xWAkVyhD4q48V6XJH"
Date: Fri, 12 Sep 2008 09:05:12 +0200
Message-Id: <1221203112.28541.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5W1xWAkVyhD4q48V6XJH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2008-09-12 at 12:05 +0530, Gautham R Shenoy wrote:

> Mike, with what --oltp-* mode did you run the sysbench test?

My cobbled together via google test script is attached.

	-Mike

--=-5W1xWAkVyhD4q48V6XJH
Content-Disposition: attachment; filename=sysbench.test
Content-Type: application/x-shellscript; name=sysbench.test
Content-Transfer-Encoding: 7bit

#!/bin/sh

dbtype=mysql
#dbtype=pgsql

tablesize="100000"

case $dbtype in
    mysql)
        connect="--mysql-host=127.0.0.1 --mysql-port=3306 --mysql-db=sbtest --mysql-user=mikeg"
        common="--test=oltp --db-driver=mysql --oltp-table-size=${tablesize}"
        ;;
    pgsql)
	sudo sh -c 'echo 134217728 > /proc/sys/kernel/shmmax'
	pg_ctl -D /home/mikeg/postgres -l logfile start
	sleep 5
#	dropdb sbtest
#	createdb sbtest
#	sysbench --test=oltp --pgsql-user=mikeg --db-driver=pgsql --oltp-table-size=100000 prepare

#        connect="--pgsql-host=127.0.0.1 --pgsql-port=5432 --pgsql-db=sbtest --pgsql-user=mikeg"
        connect="--pgsql-host="" --pgsql-port=5432 --pgsql-db=sbtest --pgsql-user=mikeg"
        common="--test=oltp --db-driver=pgsql --oltp-table-size=${tablesize}"
        ;;
    *)
        echo "Unknown dbtype";
        exit 1;
        ;;
esac

# system setup
steps="8 1 2 4 8 16 32 64 128 256"
# steps="256"
requests="10000"
flavor=`uname -r`

# test type, ro/rw
testtype="ro"
resultdir="sysbench_results/${RUNID}"
mkdir -p ${resultdir}
args="${common} ${connect} --max-time=60 --max-requests=0 --oltp-test-mode=complex --oltp-dist-iter=16"

case ${testtype} in
    ro)
        args="${args} --oltp-read-only=on --oltp-skip-trx=off"
        ;;
    rw)
        args="${args} --oltp-read-only=off"
        test ${dbtype} = "mysql" && args="${args} --oltp-skip-trx=on"
        test ${dbtype} = "mysql" || args="${args} --oltp-skip-trx=off"
        ;;
esac

resultfile() {
    local threads=$1
    echo ${resultdir}/${flavor}.${dbtype}.${testtype}.${threads}
}
plotdata=`echo ${resultdir}/${flavor}.${dbtype}.${testtype}.plot | tr '.-' _`

rm -f ${plotdata}
rm -f ${resultdir}/${flavor}.${testtype}.*

echo -n > ${plotdata}

for threads in ${steps}
do
    cmd="sysbench --num-threads=${threads} ${args} run"
    out=`resultfile ${threads}`
    echo ${cmd} > ${out}
    echo "Testing with ${threads}"
    success=0
    while test ${success} -eq 0;
    do
        date
        date >> ${out}
        $cmd >> ${out} && success=1
        test ${success} -eq 0 && (echo "Test failed, restarting")
    done
    cat ${out}
    awk '/read.write requests/ {sub("^.", "", $4); print $4}' ${out} >> ${plotdata}
done

# Shutdown
case $dbtype in
    mysql)
        ;;
    pgsql)
	pg_ctl -D /home/mikeg/postgres -l logfile stop
        ;;
esac

--=-5W1xWAkVyhD4q48V6XJH--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939Ab0ALJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0ALJXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410Ab0ALJXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:23:16 -0500
Received: from thinktradellc.com ([66.17.177.171]:14074 "EHLO
	old.thinktradellc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865Ab0ALJXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:23:13 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 04:23:12 EST
Message-ID: <4B4C3E4F.9060001@memeplex.com>
Date: Tue, 12 Jan 2010 04:18:07 -0500
From: Andrew Athan <linux_kernel_aathan@memeplex.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Futex hang/lockup problem in 2.6.30+ on AMD64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After some investigation I believe I am experiencing a problem similar
to the one described in this posting:
http://sourceware.org/ml/libc-help/2009-10/msg00026.html, in that the
poster suspects a problem in the futex implementation in 2.6.30 and
above kernels.  In my case, the problem is not a soft lockup in the
kernel, but it does result in an application lock up due to all threads
waiting for futex's.

For me this problem began to appear once I upgraded my Debian
squeeze/testing x86_64 installation (AMD) to a new kernel.  I'm not
sure what the prior kernel version was.  The same software running on
different machines with earlier kernels (lenny) does not seem to
experience the problem.

I'm really not sure if this is a libc or kernel problem, but due to
the stack trace, which shows what appears to be a hang on the internal
__lock of the condition variable, it appears likely this is not an
application bug.  Memory does not appear to be corrupt (I store
sentinels around the mutexes, and they have retained their values).

It appears that the cond var's __lock indicates there are waiters
even though there are/should-be none (assuming I'm interpreting the
__lock value of 2 correctly).  Since the __lock in question is a futex
primitive, and it must be held regardless of other libc/nptl state 
variables,
I don't believe this is a libc problem.

The problem occurs rarely, but innevitably, and sometimes only after
several hours of normal program operation.  I have not yet
successfully created a reduced test program that can faithfully
reproduce the hang in a short timeframe.

The application contains a thread pool where threads perform many
operations between pthread calls but can be summarized as one of three
cases below.  Due to the design of the thread pool, threads
round-robbin or at least are randomly assigned a workload (in contrast
to having one constant broadcast thread).

case 1:  while(1){ *A* pthread_lock();pthread_unlock();}
case 2:  pthread_lock();pthread_cond_wait();pthread_unlock();
case 3:  pthread_lock(); *B* pthread_cond_broadcast();pthread_unlock();

The application becomes hung with all threads but one stuck at *A*,
and one thread at *B*.

The stack trace and other details appear below.  I've saved the core
file in case I can provide additional information.


$ uname -a
Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64 
GNU/Linux

I rebuilt Debian's eglibc-2.10.2 from source with -g flag to get a 
better trace.  Here is ldd on the application:

    linux-vdso.so.1 =>  (0x00007fff149ff000)
    libboost_python.so.1.40.0 => ./libboost_python.so.1.40.0 
(0x00007f1f2c55a000)
    libpython2.5.so.1.0 => /usr/lib/libpython2.5.so.1.0 (0x00007f1f2c1e1000)
    libACEXML_Parser.so.5.4.0 => /var/ACE/libACEXML_Parser.so.5.4.0 
(0x00007f1f2bfbf000)
    libACEXML.so.5.4.0 => /var/ACE/libACEXML.so.5.4.0 (0x00007f1f2bd77000)
    libACE.so.5.4.0 => /var/ACE/libACE.so.5.4.0 (0x00007f1f2acc3000)
    libdl.so.2 => /lib/libdl.so.2 (0x00007f1f2aabf000)
    libpthread.so.0 => 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0 
(0x00007f1f2a8a2000)
    librt.so.1 => /lib/librt.so.1 (0x00007f1f2a69a000)
    libstdc++.so.6 => /usr/lib/libstdc++.so.6 (0x00007f1f2a38a000)
    libm.so.6 => /lib/libm.so.6 (0x00007f1f2a107000)
    libgcc_s.so.1 => /lib/libgcc_s.so.1 (0x00007f1f29ef1000)
    libc.so.6 => /lib/libc.so.6 (0x00007f1f29b9d000)
    libutil.so.1 => /lib/libutil.so.1 (0x00007f1f29999000)
    /lib64/ld-linux-x86-64.so.2 (0x00007f1f2c7b1000)


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
GDB BACKTRACE
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

See below for source of last couple of stack frames.

All threads except thread 4 are waiting for a lock on the "external"
mutex being used in conjunction with the condition variable.  The
owner of that lock is 25521 which sure enough is thread 4.  However,
thread 4 appears to be waiting on the internal __lock of the condition
variable.  Since that variable appears to have no waiters and the
other threads' traces are not inside any pthread calls associated with
that __lock, it seems reasonable that there is either a pthread or
futex problem.



Thread 7 (Thread 25524):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b282e79 in _L_lock_949 () from 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0
#2  0x00007f9c9b282c9b in __pthread_mutex_lock (mutex=0x1dc3960) at 
pthread_mutex_lock.c:61
#3  0x00007f9c9c545021 in ACE_OS::mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:1296
#4  0x00007f9c9c545061 in ACE_OS::thread_mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:4443
#5  0x00007f9c9c54508f in ACE_Thread_Mutex::acquire (this=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Thread_Mutex.inl:57
#6  0x00007f9c9c5410e2 in ACE_Guard<ACE_Thread_Mutex>::acquire 
(this=0x7f9c7f7f5e90)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:9
#7  0x00007f9c9c541123 in ACE_Guard (this=0x7f9c7f7f5e90, l=...)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:35
#8  0x00007f9c9c2e1da6 in TTWork::GeneratorSelect::reselect 
(this=0x1dc38f0, wi=0x7f9c80af9660) at TTWork.cpp:873
#9  0x00007f9c9c2e1e92 in TTWork::WorkItemHandle::clearReadyMask 
(this=0x7f9c80af9660, mask=1, resel=true)
    at TTWork.cpp:1061
#10 0x00007f9c9c2eaea2 in TTWork::NetServiceTCP::doTheWork 
(this=0x7f9c80af9660, workEV=...)
    at TTWorkNetServiceTCP.cpp:278
#11 0x00007f9c9c2eb354 in TTWork::NetServiceTCP::doWork 
(this=0x7f9c80af9660, workEV=...)
    at TTWorkNetServiceTCP.cpp:351
#12 0x00007f9c9c2dfccb in TTWork::Dispatcher::dispatch (this=0x13b5c60) 
at TTWork.cpp:234
#13 0x00007f9c9c2e3a4f in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c7f7f6260)
    at TTWork.cpp:324
#14 0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#15 0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#16 0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#17 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i 
(this=0x7f9c80000bc0) at Thread_Adapter.cpp:150
#18 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke 
(this=0x7f9c80000bc0) at Thread_Adapter.cpp:93
#19 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x7f9c80000bc0) at 
Base_Thread_Adapter.cpp:131
#20 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#21 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#22 0x0000000000000000 in ?? ()

Thread 6 (Thread 25523):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b282e79 in _L_lock_949 () from 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0
#2  0x00007f9c9b282c9b in __pthread_mutex_lock (mutex=0x1dc3960) at 
pthread_mutex_lock.c:61
#3  0x00007f9c9c545021 in ACE_OS::mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:1296
#4  0x00007f9c9c545061 in ACE_OS::thread_mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:4443
#5  0x00007f9c9c54508f in ACE_Thread_Mutex::acquire (this=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Thread_Mutex.inl:57
#6  0x00007f9c9c5410e2 in ACE_Guard<ACE_Thread_Mutex>::acquire 
(this=0x7f9c7fff6e90)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:9
#7  0x00007f9c9c541123 in ACE_Guard (this=0x7f9c7fff6e90, l=...)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:35
#8  0x00007f9c9c2e1da6 in TTWork::GeneratorSelect::reselect 
(this=0x1dc38f0, wi=0x7f9c80ab8e40) at TTWork.cpp:873
#9  0x00007f9c9c2e1e92 in TTWork::WorkItemHandle::clearReadyMask 
(this=0x7f9c80ab8e40, mask=1, resel=true)
    at TTWork.cpp:1061
#10 0x00007f9c9c2eaea2 in TTWork::NetServiceTCP::doTheWork 
(this=0x7f9c80ab8e40, workEV=...)
    at TTWorkNetServiceTCP.cpp:278
#11 0x00007f9c9c2eb354 in TTWork::NetServiceTCP::doWork 
(this=0x7f9c80ab8e40, workEV=...)
    at TTWorkNetServiceTCP.cpp:351
#12 0x00007f9c9c2dfccb in TTWork::Dispatcher::dispatch (this=0x13b5c60) 
at TTWork.cpp:234
#13 0x00007f9c9c2e3a4f in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c7fff7260)
    at TTWork.cpp:324
#14 0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#15 0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#16 0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#17 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i 
(this=0x7f9c80000970) at Thread_Adapter.cpp:150
#18 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke 
(this=0x7f9c80000970) at Thread_Adapter.cpp:93
#19 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x7f9c80000970) at 
Base_Thread_Adapter.cpp:131
#20 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#21 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#22 0x0000000000000000 in ?? ()

Thread 5 (Thread 25522):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b282e79 in _L_lock_949 () from 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0
#2  0x00007f9c9b282c9b in __pthread_mutex_lock (mutex=0x1dc3960) at 
pthread_mutex_lock.c:61
#3  0x00007f9c9c545021 in ACE_OS::mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:1296
#4  0x00007f9c9c545061 in ACE_OS::thread_mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:4443
#5  0x00007f9c9c54508f in ACE_Thread_Mutex::acquire (this=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Thread_Mutex.inl:57
#6  0x00007f9c9c5410e2 in ACE_Guard<ACE_Thread_Mutex>::acquire 
(this=0x7f9c84e14e90)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:9
#7  0x00007f9c9c541123 in ACE_Guard (this=0x7f9c84e14e90, l=...)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:35
#8  0x00007f9c9c2e1da6 in TTWork::GeneratorSelect::reselect 
(this=0x1dc38f0, wi=0x7f9c80407020) at TTWork.cpp:873
#9  0x00007f9c9c2e1e92 in TTWork::WorkItemHandle::clearReadyMask 
(this=0x7f9c80407020, mask=1, resel=true)
    at TTWork.cpp:1061
#10 0x00007f9c9c2eaea2 in TTWork::NetServiceTCP::doTheWork 
(this=0x7f9c80407020, workEV=...)
    at TTWorkNetServiceTCP.cpp:278
#11 0x00007f9c9c2eb354 in TTWork::NetServiceTCP::doWork 
(this=0x7f9c80407020, workEV=...)
    at TTWorkNetServiceTCP.cpp:351
#12 0x00007f9c9c2dfccb in TTWork::Dispatcher::dispatch (this=0x13b5c60) 
at TTWork.cpp:234
#13 0x00007f9c9c2e3a4f in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c84e15260)
    at TTWork.cpp:324
#14 0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#15 0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#16 0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#17 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i 
(this=0x7f9c80000bc0) at Thread_Adapter.cpp:150
#18 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke 
(this=0x7f9c80000bc0) at Thread_Adapter.cpp:93
#19 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x7f9c80000bc0) at 
Base_Thread_Adapter.cpp:131
#20 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#21 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#22 0x0000000000000000 in ?? ()

Thread 4 (Thread 25521):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b2854d0 in pthread_cond_broadcast@@GLIBC_2.3.2 ()
    at ../nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_broadcast.S:118
#2  0x00007f9c9c2b87c7 in ACE_OS::cond_broadcast (cv=0x1dc4500)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6/ace/OS_NS_Thread.inl:294
#3  0x00007f9c9c2b5325 in ACE_Condition<ACE_Thread_Mutex>::broadcast 
(this=0x1dc4500)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6/ace/Condition_T.inl:81
#4  0x00007f9c9c2e229e in TTWork::GeneratorSelect::generate 
(this=0x1dc38f0, nextGenTime=...,
    maxWait=0x7f9c856161c0) at TTWork.cpp:814
#5  0x00007f9c9c2e38f2 in TTWork::Dispatcher::generate (this=0x13b5c60, 
maxWait=0x7f9c85616220, min=0x7f9c85616260)
    at TTWork.cpp:300
#6  0x00007f9c9c2e3a9b in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c85616260)
    at TTWork.cpp:331
#7  0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#8  0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#9  0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#10 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i 
(this=0x7f9c80000970) at Thread_Adapter.cpp:150
#11 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke 
(this=0x7f9c80000970) at Thread_Adapter.cpp:93
#12 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x7f9c80000970) at 
Base_Thread_Adapter.cpp:131
#13 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#14 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#15 0x0000000000000000 in ?? ()

Thread 3 (Thread 25520):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b282e79 in _L_lock_949 () from 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0
#2  0x00007f9c9b282c9b in __pthread_mutex_lock (mutex=0x1dc3960) at 
pthread_mutex_lock.c:61
#3  0x00007f9c9c545021 in ACE_OS::mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:1296
#4  0x00007f9c9c545061 in ACE_OS::thread_mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:4443
#5  0x00007f9c9c54508f in ACE_Thread_Mutex::acquire (this=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Thread_Mutex.inl:57
#6  0x00007f9c9c5410e2 in ACE_Guard<ACE_Thread_Mutex>::acquire 
(this=0x7f9c85e16e90)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:9
#7  0x00007f9c9c541123 in ACE_Guard (this=0x7f9c85e16e90, l=...)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:35
#8  0x00007f9c9c2e1da6 in TTWork::GeneratorSelect::reselect 
(this=0x1dc38f0, wi=0x7f9c78177200) at TTWork.cpp:873
#9  0x00007f9c9c2e1e92 in TTWork::WorkItemHandle::clearReadyMask 
(this=0x7f9c78177200, mask=1, resel=true)
    at TTWork.cpp:1061
#10 0x00007f9c9c2eaea2 in TTWork::NetServiceTCP::doTheWork 
(this=0x7f9c78177200, workEV=...)
    at TTWorkNetServiceTCP.cpp:278
#11 0x00007f9c9c2eb354 in TTWork::NetServiceTCP::doWork 
(this=0x7f9c78177200, workEV=...)
    at TTWorkNetServiceTCP.cpp:351
#12 0x00007f9c9c2dfccb in TTWork::Dispatcher::dispatch (this=0x13b5c60) 
at TTWork.cpp:234
#13 0x00007f9c9c2e3a4f in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c85e17260)
    at TTWork.cpp:324
#14 0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#15 0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#16 0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#17 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i (this=0x13b5b20) 
at Thread_Adapter.cpp:150
#18 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke (this=0x13b5b20) at 
Thread_Adapter.cpp:93
#19 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x13b5b20) at 
Base_Thread_Adapter.cpp:131
#20 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#21 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#22 0x0000000000000000 in ?? ()

Thread 2 (Thread 25519):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b282e79 in _L_lock_949 () from 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0
#2  0x00007f9c9b282c9b in __pthread_mutex_lock (mutex=0x1dc3960) at 
pthread_mutex_lock.c:61
#3  0x00007f9c9c545021 in ACE_OS::mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:1296
#4  0x00007f9c9c545061 in ACE_OS::thread_mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:4443
#5  0x00007f9c9c54508f in ACE_Thread_Mutex::acquire (this=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Thread_Mutex.inl:57
#6  0x00007f9c9c5410e2 in ACE_Guard<ACE_Thread_Mutex>::acquire 
(this=0x7f9c86617e90)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:9
#7  0x00007f9c9c541123 in ACE_Guard (this=0x7f9c86617e90, l=...)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:35
#8  0x00007f9c9c2e1da6 in TTWork::GeneratorSelect::reselect 
(this=0x1dc38f0, wi=0x2ee6240) at TTWork.cpp:873
#9  0x00007f9c9c2e1e92 in TTWork::WorkItemHandle::clearReadyMask 
(this=0x2ee6240, mask=1, resel=true)
    at TTWork.cpp:1061
#10 0x00007f9c9c2eaea2 in TTWork::NetServiceTCP::doTheWork 
(this=0x2ee6240, workEV=...)
    at TTWorkNetServiceTCP.cpp:278
#11 0x00007f9c9c2eb354 in TTWork::NetServiceTCP::doWork (this=0x2ee6240, 
workEV=...) at TTWorkNetServiceTCP.cpp:351
#12 0x00007f9c9c2dfccb in TTWork::Dispatcher::dispatch (this=0x13b5c60) 
at TTWork.cpp:234
#13 0x00007f9c9c2e3a4f in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c86618260)
    at TTWork.cpp:324
#14 0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#15 0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#16 0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#17 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i (this=0x1dc2cb0) 
at Thread_Adapter.cpp:150
#18 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke (this=0x1dc2cb0) at 
Thread_Adapter.cpp:93
#19 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x1dc2cb0) at 
Base_Thread_Adapter.cpp:131
#20 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#21 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#22 0x0000000000000000 in ?? ()

Thread 1 (Thread 25518):
#0  __lll_lock_wait () at 
../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:136
#1  0x00007f9c9b282e79 in _L_lock_949 () from 
/home/root/eglibc-2.10.2/build-tree/amd64-libc/nptl/libpthread.so.0
#2  0x00007f9c9b282c9b in __pthread_mutex_lock (mutex=0x1dc3960) at 
pthread_mutex_lock.c:61
#3  0x00007f9c9c545021 in ACE_OS::mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:1296
#4  0x00007f9c9c545061 in ACE_OS::thread_mutex_lock (m=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/OS_NS_Thread.inl:4443
#5  0x00007f9c9c54508f in ACE_Thread_Mutex::acquire (this=0x1dc3960)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Thread_Mutex.inl:57
#6  0x00007f9c9c5410e2 in ACE_Guard<ACE_Thread_Mutex>::acquire 
(this=0x7f9c86e18e90)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:9
#7  0x00007f9c9c541123 in ACE_Guard (this=0x7f9c86e18e90, l=...)
    at /opt/ttdev/ACE/v5.4/x86_64.linux2.6-testing/ace/Guard_T.inl:35
#8  0x00007f9c9c2e1da6 in TTWork::GeneratorSelect::reselect 
(this=0x1dc38f0, wi=0x7f9c78463100) at TTWork.cpp:873
#9  0x00007f9c9c2e1e92 in TTWork::WorkItemHandle::clearReadyMask 
(this=0x7f9c78463100, mask=1, resel=true)
    at TTWork.cpp:1061
#10 0x00007f9c9c2eaea2 in TTWork::NetServiceTCP::doTheWork 
(this=0x7f9c78463100, workEV=...)
    at TTWorkNetServiceTCP.cpp:278
#11 0x00007f9c9c2eb354 in TTWork::NetServiceTCP::doWork 
(this=0x7f9c78463100, workEV=...)
    at TTWorkNetServiceTCP.cpp:351
#12 0x00007f9c9c2dfccb in TTWork::Dispatcher::dispatch (this=0x13b5c60) 
at TTWork.cpp:234
#13 0x00007f9c9c2e3a4f in TTWork::Dispatcher::dispatchGenerate 
(this=0x13b5c60, maxWait=0x0, min=0x7f9c86e19260)
    at TTWork.cpp:324
#14 0x00007f9c9c2e44fd in TTWork::DispatcherTask::runTask 
(this=0x13b6ec0) at TTWork.cpp:1580
#15 0x00007f9c9c2e4fee in TTWork::Task::svc (this=0x13b6ec0) at 
TTWork.cpp:50
#16 0x00007f9c9b865344 in ACE_Task_Base::svc_run (args=0x13b6ee8) at 
Task.cpp:210
#17 0x00007f9c9b7dcb0f in ACE_Thread_Adapter::invoke_i (this=0x1dc2a60) 
at Thread_Adapter.cpp:150
#18 0x00007f9c9b7dcbb9 in ACE_Thread_Adapter::invoke (this=0x1dc2a60) at 
Thread_Adapter.cpp:93
#19 0x00007f9c9b78c0e3 in ace_thread_adapter (args=0x1dc2a60) at 
Base_Thread_Adapter.cpp:131
#20 0x00007f9c9b28073a in start_thread (arg=<value optimized out>) at 
pthread_create.c:300
#21 0x00007f9c9a64169d in clone () from /lib/libc.so.6
#22 0x0000000000000000 in ?? ()



+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DETAILS
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Note => markers in stack traces below for PC location




THREAD 4 -- hung in futex call getting internal __lock while holding 
external mutex
--------------------------------------------------

Caller's view of the condition variable...
(gdb) p cv
$4 = (ACE_cond_t *) 0x1dc4500
(gdb) p *cv
$5 = {__data = {__lock = 2, __futex = 0, __total_seq = 0, __wakeup_seq = 
0, __woken_seq = 0, __mutex = 0x0,
    __nwaiters = 0, __broadcast_seq = 0}, __size = "\002", '\000' 
<repeats 46 times>, __align = 2}


C code from glibc/nptl:

int
__pthread_cond_broadcast (cond)
     pthread_cond_t *cond;
{
  int pshared = (cond->__data.__mutex == (void *) ~0l)
                ? LLL_SHARED : LLL_PRIVATE;
  /* Make sure we are alone.  */
  lll_lock (cond->__data.__lock, pshared);

  /* Are there any waiters to be woken?  */
  if (cond->__data.__total_seq > cond->__data.__wakeup_seq)
    {
      /* Yes.  Mark them all as woken.  */
      cond->__data.__wakeup_seq = cond->__data.__total_seq;
      cond->__data.__woken_seq = cond->__data.__total_seq;


Lowest stack from gdb (I guess what was actually compiled is a hand 
coded assembly version of above):

    .globl    __pthread_cond_broadcast
    .type    __pthread_cond_broadcast, @function
    .align    16
__pthread_cond_broadcast:

    /* Get internal lock.  */
    movl    $1, %esi
    xorl    %eax, %eax
    LOCK
#if cond_lock == 0
    cmpxchgl %esi, (%rdi)
#else
    cmpxchgl %esi, cond_lock(%rdi)
#endif
    jnz    1f

2:    addq    $cond_futex, %rdi
    movq    total_seq-cond_futex(%rdi), %r9
    cmpq    wakeup_seq-cond_futex(%rdi), %r9
    jna    4f

    /* Cause all currently waiting threads to recognize they are
       woken up.  */
    movq    %r9, wakeup_seq-cond_futex(%rdi)
    movq    %r9, woken_seq-cond_futex(%rdi)
    addq    %r9, %r9
    movl    %r9d, (%rdi)
    incl    broadcast_seq-cond_futex(%rdi)

    /* Get the address of the mutex used.  */
    movq    dep_mutex-cond_futex(%rdi), %r8

    /* Unlock.  */
    LOCK
    decl    cond_lock-cond_futex(%rdi)
    jne    7f

8:    cmpq    $-1, %r8
    je    9f

    /* XXX: The kernel so far doesn't support requeue to PI futex.  */
    /* XXX: The kernel only supports FUTEX_CMP_REQUEUE to the same
       type of futex (private resp. shared).  */
    testl    $(PI_BIT | PS_BIT), MUTEX_KIND(%r8)
    jne    9f

    /* Wake up all threads.  */
#ifdef __ASSUME_PRIVATE_FUTEX
    movl    $(FUTEX_CMP_REQUEUE|FUTEX_PRIVATE_FLAG), %esi
#else
    movl    %fs:PRIVATE_FUTEX, %esi
    orl    $FUTEX_CMP_REQUEUE, %esi
#endif
    movl    $SYS_futex, %eax
    movl    $1, %edx
    movl    $0x7fffffff, %r10d
    syscall

    /* For any kind of error, which mainly is EAGAIN, we try again
       with WAKE.  The general test also covers running on old
       kernels.  */
    cmpq    $-4095, %rax
    jae    9f

10:    xorl    %eax, %eax
    retq

    .align    16
    /* Unlock.  */
4:    LOCK
    decl    cond_lock-cond_futex(%rdi)
    jne    5f

6:    xorl    %eax, %eax
    retq

    /* Initial locking failed.  */
1:
#if cond_lock != 0
    addq    $cond_lock, %rdi
#endif
    cmpq    $-1, dep_mutex-cond_lock(%rdi)
    movl    $LLL_PRIVATE, %eax
    movl    $LLL_SHARED, %esi
    cmovne    %eax, %esi
=>    callq    __lll_lock_wait
#if cond_lock != 0
    subq    $cond_lock, %rdi
#endif
    jmp    2b


..................................................
next stack down
..................................................

#ifdef NOT_IN_libc
        .globl  __lll_lock_wait
        .type   __lll_lock_wait,@function
    .hidden __lll_lock_wait
    .align  16
__lll_lock_wait:
    cfi_startproc
    pushq   %r10
    cfi_adjust_cfa_offset(8)
    pushq   %rdx
    cfi_adjust_cfa_offset(8)
    cfi_offset(%r10, -16)
        cfi_offset(%rdx, -24)
    xorq    %r10, %r10      /* No timeout.  */
    movl    $2, %edx
    LOAD_FUTEX_WAIT (%esi)

    cmpl    %edx, %eax      /* NB:   %edx == 2 */
    jne     2f

1:      movl    $SYS_futex, %eax
    syscall

=>      movl    %edx, %eax
    xchgl   %eax, (%rdi)    /* NB:   lock is implied */

    testl   %eax, %eax
    jnz     1b




OTHER THREADS -- waiting to get the external mutex
--------------------------------------------------
Caller's view of the mutex

(gdb) p m
$2 = (ACE_thread_mutex_t *) 0x1dc3960
(gdb) p *m
$3 = {__data = {__lock = 2, __count = 0, __owner = 25521, __nusers = 1, 
__kind = 0, __spins = 0, __list = {
      __prev = 0x0, __next = 0x0}},

Lower stack levels:

int
__pthread_mutex_lock (mutex)
     pthread_mutex_t *mutex;
{
  assert (sizeof (mutex->__size) >= sizeof (mutex->__data));

  unsigned int type = PTHREAD_MUTEX_TYPE (mutex);
  if (__builtin_expect (type & ~PTHREAD_MUTEX_KIND_MASK_NP, 0))
    return __pthread_mutex_lock_full (mutex);

  pid_t id = THREAD_GETMEM (THREAD_SELF, tid);

  if (__builtin_expect (type, PTHREAD_MUTEX_TIMED_NP)
      == PTHREAD_MUTEX_TIMED_NP)
    {
    simple:
      /* Normal mutex.  */
=>    LLL_MUTEX_LOCK (mutex);
      assert (mutex->__data.__owner == 0);

..................................................
next stack down
..................................................
#ifdef NOT_IN_libc
        .globl  __lll_lock_wait
        .type   __lll_lock_wait,@function
    .hidden __lll_lock_wait
    .align  16
__lll_lock_wait:
    cfi_startproc
    pushq   %r10
    cfi_adjust_cfa_offset(8)
    pushq   %rdx
    cfi_adjust_cfa_offset(8)
    cfi_offset(%r10, -16)
        cfi_offset(%rdx, -24)
    xorq    %r10, %r10      /* No timeout.  */
    movl    $2, %edx
    LOAD_FUTEX_WAIT (%esi)

    cmpl    %edx, %eax      /* NB:   %edx == 2 */
    jne     2f

1:      movl    $SYS_futex, %eax
    syscall

=>      movl    %edx, %eax
    xchgl   %eax, (%rdi)    /* NB:   lock is implied */


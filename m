Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYJ3W2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYJ3W2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJ3W2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:28:06 -0400
Received: from host4.CastelHQ.com ([66.152.210.4]:11510 "EHLO
	casmail.hq.castel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbYJ3W2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:28:04 -0400
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 18:28:04 EDT
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {9C36A52D-6439-4841-922F-2AF570B4B2C4}
X-MimeOLE: Produced By Microsoft Exchange V6.5
x-cr-hashedpuzzle: CD67 Cw1D DCCx DKs/ Done EK38 EVuv EnqU FGyd GoHk G2Eb JEvr J1tO J4KR KgCN Kr08;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{9C36A52D-6439-4841-922F-2AF570B4B2C4};agByAGUAbgB0AG8AbgBAAGMAYQBzAHQAZQBsAC4AYwBvAG0A;Thu, 30 Oct 2008 22:12:14 GMT;cwBpAGcAcQB1AGUAdQBlACgAKQAgAGwAbwBzAGkAbgBnACAAcwBpAGcAbgBhAGwAcwA=
Content-class: urn:content-classes:message
Subject: sigqueue() losing signals
Date: Thu, 30 Oct 2008 18:12:14 -0400
Message-ID: <10058ACA10EE3444BBBC5FCF84825F63417127@casmail.hq.castel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sigqueue() losing signals
Thread-Index: Ack63JBKYgFDwt9kS9OdY3I9inn/tA==
From: "James Renton" <jrenton@castel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Joe Maldonado" <jmaldonado@castel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I needed to kick off a bunch of background threads and receive
notification if one failed due to fatal error.  I was hoping waitpid()
would work; but found out quickly that although each thread has a pid_t;
threads and processes were not interchangeable.  Without a timed
pthread_join() over multiple threads (like WIN32
WaitForMultipleObjects), I formulated a seemingly dead simple
implementation using signals.  I hacked out a quick prototype to ensure
I could get the signals to work as desired.  

When I ran the prototype, I experienced behavior looking very bug-like;
but I wanted to post it here in case I am misunderstanding unix signals
and just doing something silly.  I am requesting for comments or
[hopefully clever] suggestions... Code follows:

<CODE>
#include <pthread.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <errno.h>

siginfo_t signal_info;
pthread_t thread_main;
pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;

_syscall0(pid_t,gettid)

void *fThrd( void *context )
{
    union sigval val;
    val.sival_int = gettid();
    printf( "{%d} TID started OK\n", gettid() );
    sleep( 5 );
    printf( "{%d} TID exiting...\n", gettid() );

    //xxpthread_mutex_lock( &mtx );
    while( 0!=sigqueue( getpid(), SIGCHLD, val ) )
    {
        printf( "ERR=[%d]\n", errno );
        if( EAGAIN!=errno )
            break;
        //xxusleep( 10000 );
    }
    //xxusleep( 10000 );
    //xxpthread_mutex_unlock( &mtx );
};

void fSigChld( int signal, siginfo_t *pInfo, void* context )
{
    printf( "{%d} SIGCHLD called...\n", gettid() );
    if( getpid()!=gettid() || signal!=SIGCHLD )
        return;
    memcpy( &signal_info, pInfo, sizeof(siginfo_t) );
    printf( "{%d} SIGCHLD executed OK\n", gettid() );
}

int main( int argc, char* argv[] )
{
    pthread_t hT = 0;
    struct sigaction act;
    int rc = -1,i;
    const pid_t ppid = getppid();
  
    thread_main = pthread_self();

    memset( &signal_info, 0x00, sizeof(signal_info) );
    printf( "{%d} Parent PID={%d}\n", gettid(), ppid ); 

    for( i=0;i<5;i++ )
         rc = pthread_create( &hT, NULL, &fThrd, NULL );

    memset( &act, 0x00, sizeof(act) );   
    act.sa_flags = SA_SIGINFO;
    act.sa_sigaction = &fSigChld;
    rc = sigaction( SIGCHLD, &act, NULL );

    for( ;; )
    {
       printf( "{%d} PID sleeping...\n", gettid() );
       sleep(11);
       if( 0!=signal_info.si_pid )
           printf( "  SIGNAL SRC={%d} OK\n",
signal_info.si_value.sival_int);
       memset( &signal_info, 0x00, sizeof(signal_info) );     
    };

    printf( "{%d} PID exiting...\n", gettid() );
    return rc;    
};
</CODE>

When I execute it in 2.6.9-42.EL, I get the following output:
{10321} Parent PID={10235}
{10321} PID sleeping...
{10322} TID started OK
{10323} TID started OK
{10324} TID started OK
{10325} TID started OK
{10326} TID started OK
{10322} TID exiting...
{10323} TID exiting...
{10324} TID exiting...
{10325} TID exiting...
{10326} TID exiting...
{10321} SIGCHLD called...
{10321} SIGCHLD executed OK
  SIGNAL SRC={10322} OK
{10321} PID sleeping...
{10321} PID sleeping...

As you can see, 4/5 of the signals are lost.

When I uncomment the other lines above, (in fThrd); the output looks
better:
{10355} Parent PID={10235}
{10355} PID sleeping...
{10356} TID started OK
{10357} TID started OK
{10358} TID started OK
{10359} TID started OK
{10360} TID started OK
{10356} TID exiting...
{10357} TID exiting...
{10358} TID exiting...
{10359} TID exiting...
{10360} TID exiting...
{10355} SIGCHLD called...
{10355} SIGCHLD executed OK
  SIGNAL SRC={10356} OK
{10355} PID sleeping...
{10355} SIGCHLD called...
{10355} SIGCHLD executed OK
  SIGNAL SRC={10357} OK
{10355} PID sleeping...
{10355} SIGCHLD called...
{10355} SIGCHLD executed OK
  SIGNAL SRC={10358} OK
{10355} PID sleeping...
{10355} SIGCHLD called...
{10355} SIGCHLD executed OK
  SIGNAL SRC={10359} OK
{10355} PID sleeping...
{10355} SIGCHLD called...
{10355} SIGCHLD executed OK
  SIGNAL SRC={10360} OK
{10355} PID sleeping...
{10355} PID sleeping...

James
Beverly, MA USA



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXIVUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXIVUTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbXIVUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:19:08 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:33240 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXIVUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:19:07 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Should parent's WIFSIGNALED(siginfo->si_status) be true EVEN IF the SIGNAL was caught by the child?
Date: Sat, 22 Sep 2007 13:18:53 -0700
User-Agent: KMail/1.9.6
References: <200709221122.09523.jzb2@aexorsyst.com> <517f3f820709221149x761abea8vf7e3529f0f3ddc64@mail.gmail.com>
In-Reply-To: <517f3f820709221149x761abea8vf7e3529f0f3ddc64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tiX9GF+KEYZ+mxm"
Message-Id: <200709221318.53579.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tiX9GF+KEYZ+mxm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 22 September 2007 11:49:09 Michael Kerrisk wrote:
> John,
>

...snip...

>
> If the child terminated by calling exit(), regardless of whether it
> was done from inside a signal handler, then WIFEXITED() should test
> true, but WIFSIGNALED() will not.  If you are seeing otherwise, then
> show a *short* program that demonstrates the behavior.  (But it seems
> unlikely that there would be a kernel bug on this point, so do check
> your program carefully!)

Attached is a (somewhat) short program that demonstates the behavior.  I 
simply compile it with 'make sigtest'.

My observed behavior is:

$ ./sigtest
sigtest started
child1 started
child2 started
selecting...
sigCaught: 3366 receieved signal 15
sigtest 3366 exiting
sigChld: 3365 receieved signal 17
sigChld: 3365 child 3366 WIFEXITED with childStat 15
sigChld: 3365 child 3366 WIFSIGNALED with si_status 15
select error: Interrupted system call
selecting...
sigCaught: 3367 receieved signal 15
sigtest 3367 exiting
sigChld: 3365 receieved signal 17
sigChld: 3365 child 3367 WIFEXITED with childStat 15
sigChld: 3365 child 3367 WIFSIGNALED with si_status 15
select error: Interrupted system call
selecting...
sigCaught: 3365 receieved signal 15
sigtest 3365 exiting
$

To get this output, I ran, from another shell, the following sequence:

$ ps -eaf | grep sigtest
zoltan    3365  2307  0 13:04 pts/0    00:00:00 ./sigtest
zoltan    3366  3365 98 13:04 pts/0    00:00:06 ./sigtest
zoltan    3367  3365 98 13:04 pts/0    00:00:06 ./sigtest
$ kill -SIGTERM 3366
$ kill -SIGTERM 3367
$ kill -SIGTERM 3365

That's it.  What I find odd is that the wait_pid() status and the 
si_status are the same for both a WIFEXITED and a WIFSIGNALED, which 
should be impossible, if I read the documentation right.

Thanks for your responses,
John





--Boundary-00=_tiX9GF+KEYZ+mxm
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="sigtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sigtest.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>
#include <pwd.h>
#include <signal.h>
#include <syslog.h>

#include <netinet/in.h>

#include <sys/types.h>
#include <sys/inotify.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/wait.h>

#define SER_PORT_ID     1234             /* The server's port */

static int child;                        /* child = 0, parent != 0 */

static void child1(void);
static void child2(void);
static void sigChld(int signum, siginfo_t * siginfo, void * ucontext);
static void sigCaught(int signum, siginfo_t * siginfo, void * ucontext);
static void setupEnv(void);
static void serverLoop(void);
static void processConnect(int csfd);
static void sigtestExit();

/**
 * main:
 * @argc: The count of command line data
 * @argv: The array of command line strings
 *
 * The entry point of the executable.
 */
int
main(int argc, char * argv[])
{
    setupEnv();

    /*
     * spawn two child processes so they (the children) can be sent SIGNAL's
     * and the behaviour can be observed...
     */

    if ((child = fork()) < 0)            /* fork error */
    {
        perror("Child1 could not be created");
        exit(1);
    }
    else
        if (child == 0)                  /* In child */
        {
            child1();                    /* never returns... */
        }

    if ((child = fork()) < 0)            /* fork error */
    {
        perror("Monitor child could not be created");
        exit(1);
    }
    else
        if (child == 0)                  /* In child */
        {
            child2();                    /* never returns... */
        }

    serverLoop();                        /* Never returns */

    return 0;

}

/**
 * child1:
 *
 * This is the first child.
 */
static void
child1(void)
{
    printf("child1 started\n");

    for ( ; ; );
}

/**
 * child2:
 *
 * This is the second child.
 */
static void
child2(void)
{
    printf("child2 started\n");

    for ( ; ; );
}

/**
 * sigChild:
 * @signum: The signal that got us here.
 * @siginfo: Additional data associated with the signal.
 * @ucontext: Pointer to ucontext_t struct.  Unused here.
 *
 * Signal handler for catching SIGCHLD.  Is re-entrant...
 */
static void
sigChld(int signum, siginfo_t * siginfo, void * ucontext)
{
    int childStat;

    printf("sigChld: %d receieved signal %d\n", getpid(), signum);

    if (signum != SIGCHLD)               /* technically can't happen here... */
        return;                          /* but ignore it if it does */

    waitpid(siginfo->si_pid, &childStat, 0); /* orderly child shutdown... */

    /*
     * These next 4 if blocks are where it gets interesting...this I believe
     * demonstrates the inconsistency.
     */

    if (WIFEXITED(childStat))
        printf("sigChld: %d child %d WIFEXITED with childStat %d\n",
                getpid(), siginfo->si_pid, WEXITSTATUS(childStat));

    if (WIFEXITED(siginfo->si_status))
        printf("sigChld: %d child %d WIFEXITED with si_status %d\n",
                getpid(), siginfo->si_pid, WEXITSTATUS(siginfo->si_status));

    if (WIFSIGNALED(childStat))
    {
        printf("sigChld: %d child %d WIFSIGNALED with childStat %d\n",
                getpid(), siginfo->si_pid, WTERMSIG(childStat));
    }

    if (WIFSIGNALED(siginfo->si_status))
    {
        printf("sigChld: %d child %d WIFSIGNALED with si_status %d\n",
                getpid(), siginfo->si_pid, WTERMSIG(siginfo->si_status));
    }

    return;
}

/**
 * sigCaught:
 * @signum: The signal that got us here.
 * @siginfo: Additional data associated with the signal.
 * @ucontext: Pointer to ucontext_t struct.  Unused here.
 *
 * Signal handler for catching all but SIGCHLD.  Is re-entrant...
 */
static void
sigCaught(int signum, siginfo_t * siginfo, void * ucontext)
{
    int childStat;

    printf("sigCaught: %d receieved signal %d\n", getpid(), signum);

    if (signum == SIGCHLD)               /* technically can't happen here... */
        return;                          /* but ignore it if it does */

    exit(signum);
}

/**
 * setupEnv:
 *
 * Setup the environment, i.e, signal handlers, etc.
 */
static void
setupEnv(void)
{
    struct sigaction action;

    printf("sigtest started\n");

    atexit(sigtestExit);

    action.sa_handler = NULL;
    action.sa_sigaction = sigChld;
    sigemptyset(&action.sa_mask);

    /*
     * Since sigChld is re-entrant, its okay to have SA_NODEFER, and necessary,
     * too, since I want to waitpid() on ALL child processes, and since
     * waitpid() won't block if called after the child croaked, its just simply
     * a way to affect an orderly shutdown of child processes, avoiding the
     * zombie state...of course, I could be wrong, and without SA_NODEFER, the
     * SIGCHLD is only _temporarily_ blocked, then I'll get subsequent SIGCHLDs
     * after this handler completes...either way, in this case its irrelevant.
     */

    action.sa_flags = SA_SIGINFO | SA_NOCLDSTOP | SA_RESTART | SA_NODEFER;

    sigaction(SIGCHLD, &action, NULL);

    /*
     * Now catch the rest of the signals...
     */
    
    action.sa_handler = NULL;
    action.sa_sigaction = sigCaught;
    sigfillset(&action.sa_mask);
    action.sa_flags = SA_SIGINFO;

    sigaction(SIGINT, &action, NULL);
    sigaction(SIGHUP, &action, NULL);
    sigaction(SIGTERM, &action, NULL);
    sigaction(SIGQUIT, &action, NULL);
    sigaction(SIGTSTP, &action, NULL);
    sigaction(SIGSTOP, &action, NULL);

    return;
}

/**
 * serverLoop:
 *
 * The main loop for listening for and handling connections.
 */
static void
serverLoop(void)
{
    fd_set read_fs;
    int sfd, csfd, n, from_len, saved_errno;
    struct sockaddr_in sin;

    

    FD_ZERO(&read_fs);                   /* Clear the file descriptors */
    
    if ((sfd = socket(AF_INET,SOCK_STREAM,0)) < 0) /* Create the socket */
    {
        perror("Socket creation failed");
        exit(1);
    }

    n = 1;

    if (setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &n, sizeof(n)) < 0)
    {
        perror("setsockopt failed");
        exit(1);
    }

    bzero((caddr_t)&sin,sizeof(struct sockaddr_in));/* Zero out the sock_addr */
    
    sin.sin_family = AF_INET;            /* Internet protocol */
    sin.sin_addr.s_addr = INADDR_ANY;    /* bind all local interfaces */
    sin.sin_port = htons(SER_PORT_ID);   /* Receive on the server port */

    if (bind(sfd, (struct sockaddr *)&sin, sizeof(struct sockaddr_in)) < 0) /* Bind socket to port */
    {
        perror("Socket binding failed");
        exit(1);
    }
    
    if (listen(sfd, 10) < 0)             /* max. 10 q'd connections */
    {
        perror("Listen failed");
        exit(1);
    }
    
    for ( ; ; )                          /* main server loop */
    {
        FD_SET(sfd,&read_fs);

        do
        {
            printf("selecting...\n");

            n = select(sfd+1,&read_fs,NULL,NULL,NULL);

            if (n < 0)
            {
                saved_errno = errno;
                perror("select error");

                if (saved_errno != EINTR)
                {
                    perror("Server select error");
                    exit(1);
                }
            }
            else
                break;                   /* no error, so handle it... */
        } while (saved_errno == EINTR);  /* restart select on EINTR */

        if (FD_ISSET(sfd, &read_fs))
        {
            from_len = sizeof(struct sockaddr_in);

            printf("accepting...\n");

            if ((csfd = accept(sfd, (struct sockaddr *)&sin,
                               (socklen_t *)&from_len)) < 0)
            {
                perror("Accept error");
                exit(1);
            }

            if ((child = fork()) < 0)    /* fork error */
            {
                perror("Child could not be created");
                exit(1);
            }
            else
                if (child == 0)          /* In child */
                {
                    close(sfd);          /* Child doesn't need this */
                    processConnect(csfd); /* never returns... */
                }

            close(csfd);                 /* Parent doesn't need this one */
        } /* if (FD_ISSET(sfd,&read_fs)) */
    } /* for ( ; ; ) */

    exit(99);                            /* Never gets here... */
}

/**
 * processConnect:
 * @csfd: The socket for this connection
 *
 * This is the child process dedicated to this connection.
 */
static void
processConnect(int csfd)
{
    uint8_t * buf;
    int n = 0;

    if (!(buf = calloc((size_t)1024, sizeof(uint8_t))))
    {
        perror("calloc failed");
        exit(1);
    }

    /*
     * This means we're in the child, and have an active connection...
     */

    printf("\nReading csfd %d...\n", csfd);

    if ((n = read(csfd, buf, sizeof(buf))) < 0)
    {
        perror("Server read error");
        exit(1);
    }

    if (n == 0)
    {
        printf("Connection closed...exiting\n");
        exit(2);
    }

    printf("Read 0x%x bytes...\n", n);

    buf[n] = 0;
    printf("%s", buf);

// would do something with the data here, but this is just for testing...
    
    close(csfd);
    exit(0);                             /* child exits... */
}

/**
 * sigtestExit:
 *
 * Since master server is exiting, everyone must be killed...
 */
static void
sigtestExit()
{
    sigset_t sigset;
    
    printf("sigtest %d exiting\n", getpid());

    if (child)                           /* if the main server is exiting... */
    {
        sigfillset(&sigset);
        sigprocmask(SIG_BLOCK,&sigset,NULL); /* block all sigs... */
        kill(0,SIGTERM);                     /* everybody in this proc. group */
    }
}

--Boundary-00=_tiX9GF+KEYZ+mxm--

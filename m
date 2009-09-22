Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZIVHGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZIVHGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZIVHGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:06:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:54223 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755308AbZIVHGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:06:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+7dqcti7K7SvX8p7qwKSnP/T99tWPG9maoVsqNH9
	fGEEWv9W9QGyBG
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: James Cloos <cloos@jhcloos.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
In-Reply-To: <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <20090920080728.73bfe2a1@infradead.org>
	 <4AB5ECD0.7010903@datenparkplatz.de>
	 <1253475521.9224.43.camel@marge.simson.net> <4AB6C73C.1030004@gmail.com>
	 <1253507034.23414.90.camel@marge.simson.net>
	 <4AB72FDC.5090403@datenparkplatz.de>
	 <1253520364.25640.57.camel@marge.simson.net>
	 <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
Content-Type: multipart/mixed; boundary="=-JRMLOvHE/KN4slo7H4yM"
Date: Tue, 22 Sep 2009 09:06:33 +0200
Message-Id: <1253603193.6875.118.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JRMLOvHE/KN4slo7H4yM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Mon, 2009-09-21 at 15:47 -0400, James Cloos wrote:
> FWIW, I did not notice any problems with the last kernel I had compiled
> in the -- IIRC -- 29-rc timeframe.  Or maybe it was the 30-rc timeframe.
> 
> I had that kernel up for soemthing like five weeks, on a busy, low-ram
> laptop, w/o and long pauses or other noticeable pain.  For at least two
> years before that the best this laptop could manage before latency
> became horrific was a fortnight, and weekly reboots were desirable.
> 
> Unfortunately, before I could send out a congratulatory note (I wanted
> to first confirm that the result remained) I pulled up and started see-
> ing even worse latency then ever.
> 
> Turning ext4 barriers off helped avoid some of the new latency, and my
> current compile (master as of the 17th) is much better than .31 was.
> 
> But long pauses still occur whenever paging and backgound i/o-bound
> tasks interact.
> 
> There was a major regression in paging performance either .30 or .31
> (see above).  Interestingly, top(1) also shows less swap usage for
> the same usage patterns than with the older kernels.  I don't know
> which is cause or which is effect.

If someone has a definite good/bad cutoff for the problem they're
seeing, a git bisect (yeah, takes time) would be a good thing to try.

The "interactivity while saturating root disk" thing isn't a new problem
though, I can recall that being a problem to varying degrees forever.
(forever being defined as feb '93 -> today;)

> A git pull on a clone of Linus' tree is a great way to trigger the
> problem.  As is using Gentoo's portage to install/upgrade anything.
> (Bad python; no alligator!¹)  (Yes, that is a burlesque of the no
> doughnut joke.)

Git doesn't cause me any woes whatsoever, but my box's primary drive
isn't a slow laptop drive, ram isn't tight, and it has 4 cores.

Dunno.

If you're using the CFQ IO scheduler, IO bandwidth follows CPU nice
level, so tweaking nice tweaks both CPU and IO in one go.  ionice can
also be used to tweak IO independently.

I don't know if distros provide a tool that supports SCHED_IDLE, if so,
you can use that to set both CPU and IO usage to IDLE class in one go.

If you don't have such a tool, you can try the attached for background
loads.  Someone posted it to LKML in '98, and I've been updating/using
it for experiments ever since.  Just do schedctl -I background-job, and
the job will be as polite as CPU and IO schedulers can make it.

	-Mike

--=-JRMLOvHE/KN4slo7H4yM
Content-Disposition: attachment; filename="schedctl.c"
Content-Type: text/x-csrc; name="schedctl.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <unistd.h>
#include <sched.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#ifndef SCHED_BATCH
#define SCHED_BATCH 3
#endif
#ifndef SCHED_ISO
#define SCHED_ISO 4
#endif
#ifndef SCHED_IDLE
#define SCHED_IDLE 5
#endif
#ifndef SCHED_SYNC
#define SCHED_SYNC 6
#endif
#ifndef SCHED_RESET_ON_FORK
#define SCHED_RESET_ON_FORK 0x40000000
#endif

void usage();
void version();
void info(int pid);
void setsched(int pid, int policy, int pri, char flags);

unsigned char *ourname;
static int reset_flag;

/* flags */
#define	GOTPID		1
#define	GOTPOLICY	2
#define	GOTPRI		4
#define GOTCMD		8
#define GOTINFO		16

int main(argc, argv)
unsigned int argc;
unsigned char *argv[];
{
	int pid;
	int policy;
	int pri = 0;
	int i1;
	int i2;
	unsigned long l1;
	char *ptr;
	char flags = 0;

	ourname = argv[0];

	if (argc <= 1) {
		usage();
		exit(1);
	}

	for (i1 = 1; i1 < argc; i1++)
		if (argv[i1][0] == '-') {	/* switch */
			if (argv[i1][1] >= '0' && argv[i1][1] <= '9') {
				l1 = strtol(&argv[i1][1], &ptr, 10);
				if (*ptr || l1 < 0 || l1 > 0x7FFF) {
					fprintf(stderr,
						"invalid priority: %s\n",
						argv[i1]);
					exit(1);
				}
				pri = l1;
				flags |= GOTPRI;
				continue;
			}
			if (argv[i1][1] == '-') {	/* long opt. */
				if (!strcasecmp("help", &argv[i1][2])) {
					usage();
					exit(0);
				}
				if (!strcasecmp("version", &argv[i1][2])) {
					version();
					exit(0);
				}
				if (!strcasecmp("info", &argv[i1][2])) {
				      INFO:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
							}
							flags |= GOTPID;
						}
					}
					if (flags & GOTPID) {
						info(pid);
						exit(0);
					} else {
						flags |= GOTINFO;
//                                              fprintf(stderr,"no PID given\n");
//                                              exit(1);
					}
					continue;
				}	/* end of --info */
				if (!strcasecmp("pid", &argv[i1][2])) {
				      PID:
					i1++;
					if (i1 >= argc) {
						fprintf(stderr,
							"option requires an argument\n");
						exit(1);
					} else {
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr || l1 < 0
						    || l1 > 0x7FFF) {
							fprintf(stderr,
								"invalid PID: %s\n",
								argv[i1]);
							exit(1);
						}
						if (!l1)
							pid = getpid();
						else
							pid = l1;
						flags |= GOTPID;
					}
					continue;
				}	/* end of --pid */
				if (!strcasecmp("priority", &argv[i1][2])
				    || !strcasecmp("pri", &argv[i1][2])) {
				      PRIORITY:
					i1++;
					if (i1 >= argc) {
						fprintf(stderr,
							"option requires an argument\n");
						exit(1);
					} else {
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							fprintf(stderr,
								"invalid priority: %s\n",
								argv[i1]);
							exit(1);
						}
						pri = l1;
						flags |= GOTPRI;
					}
					continue;
				}	/* end of --priority */
				if (!strcasecmp("other", &argv[i1][2])
				    || !strcasecmp("normal", &argv[i1][2])) {
				      OTHER:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					flags |= GOTPOLICY;
					policy = SCHED_OTHER;
					continue;
				}	/* end of --other */
				if (!strcasecmp("batch", &argv[i1][2])) {
				      BATCH:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					flags |= GOTPOLICY;
					policy = SCHED_BATCH;
					continue;
				}	/* end of --batch */
				if (!strcasecmp("idle", &argv[i1][2])) {
				      IDLE:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					flags |= GOTPOLICY;
					policy = SCHED_IDLE;
					continue;
				}	/* end of --idle */
				if (!strcasecmp("sync", &argv[i1][2])) {
				      SYNC:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					flags |= GOTPOLICY;
					policy = SCHED_SYNC;
					continue;
				}	/* end of --sync */
				if (!strcasecmp("reset", &argv[i1][2])) {
				      RESET:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					reset_flag = SCHED_RESET_ON_FORK;
					continue;
				}	/* end of --reset */
				if (!strcasecmp("fifo", &argv[i1][2])) {
				      FIFO:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					flags |= GOTPOLICY;
					policy = SCHED_FIFO;
					continue;
				}	/* end of --fifo */
				if (!strcasecmp("rr", &argv[i1][2])
				    || !strcasecmp("round-robin",
						   &argv[i1][2])) {
				      RR:
					if (i1 < argc - 1) {
						i1++;
						l1 = strtol(argv[i1], &ptr, 0);
						if (*ptr) {
							i1--;
						} else {
							if (l1 < 0
							    || l1 > 0x7FFF) {
								fprintf(stderr,
									"invalid PID: %s\n",
									argv
									[i1]);
								exit(1);
							}
							if (!l1)
								pid = getpid();
							else {
								pid = l1;
								flags |= GOTPID;
							}
						}
					}
					flags |= GOTPOLICY;
					policy = SCHED_RR;
					continue;
				}
				/* end of --rr */
				fprintf(stderr,
					"warning: unknown long switch: %s\n",
					&argv[i1][2]);
				continue;
			}
			for (i2 = 1; i2 < strlen(argv[i1]); i2++)
				switch (argv[i1][i2]) {
				case 'h':
				case 'H':
				case '?':
					usage();
					exit(0);
				case 'i':
					goto INFO;
				case 'p':
					goto PID;
				case 'P':
					goto PRIORITY;
				case 'r':
					goto RESET;
				case 'N':
				case 'O':
					goto OTHER;
				case 'B':
					goto BATCH;
				case 'I':
					goto IDLE;
				case 'S':
					goto SYNC;
				case 'F':
					goto FIFO;
				case 'R':
					goto RR;
				default:
					fprintf(stderr,
						"warning: unknown switch: %c\n",
						argv[i1][i2]);
					break;
				}
		} else {	/* command */

//                      printf("command: %s\n",argv[i1]);
			if (flags & GOTPID) {
				fprintf(stderr,
					"warning: both PID and command given\n");
			} else
				pid = getpid();
			if (!(flags & (GOTPOLICY | GOTPRI))) {
				fprintf(stderr,
					"warning: neither policy nor priority given\n");
			}

			flags |= GOTCMD;

			setsched(pid, policy, pri, flags);

			execvp(argv[i1], (char **)(&argv[i1]));
			if (errno) {
				printf("%s: error: %s\n", argv[i1],
				       strerror(errno));
				exit(1);
			}
			break;
		}

	if (reset_flag && !(flags & GOTPOLICY)) {
		policy = sched_getscheduler(pid);
		flags |= GOTPOLICY;
	}

	if (flags & GOTINFO) {
		if (!(flags & GOTPID)) {
			fprintf(stderr, "no PID given\n");
			exit(1);
		}
		info(pid);
	}

	if (!(flags & (GOTCMD | GOTINFO))) {
		if (!(flags & GOTPID)) {
			fprintf(stderr, "neither PID nor command given\n");
			exit(1);
		}
		if (!(flags & (GOTPOLICY | GOTPRI))) {
			fprintf(stderr,
				"warning: neither policy nor priority given\n");
		}
		setsched(pid, policy, pri, flags);
	}
	exit(0);
}

void usage()
{
	printf("Usage: %s [options] [command [params...]]\n\n", ourname);
	printf("  --pid, -p <n>		specify process id\n");
	printf("  --fifo, -F [pid]	set scheduling policy to FIFO\n");
	printf("  --rr, -R [pid]	set scheduling policy to RR\n");
	printf("  --batch, -B [pid]	set scheduling policy to BATCH\n");
	printf("  --idle, -I [pid]	set scheduling policy to IDLE\n");
	printf("  --sync, -S [pid]	set scheduling policy to SYNC\n");
	printf("  --other, --normal,\n");
	printf("      -N, -O [pid]	specify normal scheduling\n");
	printf("  --reset, -r 		set SCHED_RESET_ON_FORK flag\n");
	printf("  --priority, --pri,\n");
	printf("      -<n>		set priority\n");
	printf("  --info, -i [pid]	show scheduling data\n");
	printf("  --help, -h, -H, -?	display this text\n");
	printf("  --version		show version data\n\n");
}

void version()
{
	printf("schedctl, version 0.95 (beta), 8-May-1998\n");
	printf("report bugs to aw@mail1.bet1.puv.fi or awik@freenet.fi\n");
}

void info(int pid)
{
	struct sched_param sp;
	int i1;

	i1 = sched_getscheduler(pid);
	if (errno == ESRCH) {
		fprintf(stderr, "process not found\n");
		return;
	}

	if (i1 & SCHED_RESET_ON_FORK) {
		i1 &= ~SCHED_RESET_ON_FORK;
		reset_flag = SCHED_RESET_ON_FORK;
	}

	printf("scheduling policy of process %d is ", pid);
	switch (i1) {
	case SCHED_FIFO:
		printf("FIFO");
		break;
	case SCHED_RR:
		printf("RR");
		break;
	case SCHED_OTHER:
		printf("OTHER (normal)");
		break;
	case SCHED_BATCH:
		printf("BATCH");
		break;
	case SCHED_ISO:
		printf("ISO");
		break;
	case SCHED_IDLE:
		printf("IDLE");
		break;
	case SCHED_SYNC:
		printf("SYNC");
		break;
	default:
		printf("**UNKNOWN**");
	}
	if (reset_flag)
		printf(" SCHED_RESET_ON_FORK");

	sched_getparam(pid, &sp);
	printf(", priority is %d\n", sp.sched_priority);
}

void setsched(int pid, int policy, int pri, char flags)
{
	struct sched_param sp;
	int i1;

	i1 = sched_getscheduler(pid);

	if (errno == ESRCH) {
		fprintf(stderr, "process not found\n");
		return;
	}

	if (!(flags & GOTPOLICY))
		policy = i1;
	sched_getparam(pid, &sp);
	if (!(flags & GOTPRI))
		pri = sp.sched_priority;
	else if (pri < sched_get_priority_min(policy)
		 || pri > sched_get_priority_max(policy)) {
		fprintf(stderr, "priority (%d) out of range\n", pri);
		return;
	}
	if (policy == SCHED_FIFO || policy == SCHED_RR) {
		if (!pri) {
			if (!sp.sched_priority)
				sp.sched_priority++;
		} else
			sp.sched_priority = pri;
	} else if (pri && (policy == SCHED_OTHER || policy == SCHED_BATCH ||
			   policy == SCHED_ISO || policy == SCHED_IDLE || policy == SCHED_SYNC))
		sp.sched_priority = 0;
	else
		sp.sched_priority = pri;
	if (sched_setscheduler(pid, policy|reset_flag, &sp)) {
		fprintf(stderr, "error #%d: %s\n", errno, strerror(errno));
		return;
	}

	i1 = sched_getscheduler(pid);
	if (i1 & SCHED_RESET_ON_FORK)
		i1 &= ~SCHED_RESET_ON_FORK;
	sched_getparam(pid, &sp);
	if (flags & GOTCMD)
		return;
	printf("scheduling policy of process %d set to ", pid);
	switch (i1) {
		case SCHED_FIFO:
			printf("FIFO");
			break;
		case SCHED_RR:
			printf("RR");
			break;
		case SCHED_OTHER:
			printf("OTHER");
			break;
		case SCHED_BATCH:
			printf("BATCH");
			break;
		case SCHED_ISO:
			printf("ISO");
			break;
		case SCHED_IDLE:
			printf("IDLE");
			break;
		case SCHED_SYNC:
			printf("SYNC");
			break;
	}

	if (reset_flag)
		printf(" SCHED_RESET_ON_FORK");
	printf("\n");
}

--=-JRMLOvHE/KN4slo7H4yM--


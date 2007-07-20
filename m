Return-Path: <linux-kernel-owner+w=401wt.eu-S933957AbXGTIMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbXGTIMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbXGTIMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:12:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:55645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313AbXGTIMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:12:34 -0400
Date: Fri, 20 Jul 2007 10:12:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Joachim Deguara <joachim.deguara@amd.com>
Cc: ricklind@us.ibm.com, lkml List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation update sched-stat.txt
Message-ID: <20070720081227.GA19355@wotan.suse.de>
References: <200707181111.31254.joachim.deguara@amd.com> <20070720072522.GB27772@wotan.suse.de> <200707200956.03872.joachim.deguara@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707200956.03872.joachim.deguara@amd.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:56:03AM +0200, Joachim Deguara wrote:
> On Friday 20 July 2007 09:25:22 Nick Piggin wrote:
> > On Wed, Jul 18, 2007 at 11:11:30AM +0200, Joachim Deguara wrote:
> > > While learning about schedstats I found that the documentation in the
> > > tree is old.  I updated it and found some interesting stuff like
> > > schedstats version 14 is the same as version and version 13 never saw a
> > > kernel release!  Also there are 6 fields in the current schedstats that
> > > are not used anymore.  Nick had made them irrelevant in commit
> > > 476d139c218e44e045e4bc6d4cc02b010b343939 but never removed them.
> > >
> > > Thanks to Rick's perl script who I borrowed some of the updated
> > > descriptions from.
> >
> > Ah, thanks, I actually didn't realise there was such good documentation
> > there. Patch looks good.
> >
> > BTW. I have a simple program to do a basic statistical summary of the
> > multiprocessor balancing if you are interested and haven't seen it.
> 
> Yes I am interested.  Actually I started down this road looking to find out if 
> task migration could be tracked and I saw that got kicked out from early 
> versions.

What do you mean by that? You mean if you can check information on the
migration events that a particular task has experienced?


> Your script could come in useful to link to in the documentation.  Rick has a 
> great page but hasn't been updated in a little while (though still up-to-date 
> as version 12==14) and his email bounced (though just a config error).

Here it is, its a bit ugly and I think it may still have a bug somewhere,
but I haven't looked at it for a while.

---
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define SCHEDSTAT_VERSION 14
struct rq_stats {
	/* sys_sched_yield stats */
	unsigned long long yld_both_empty;
	unsigned long long yld_act_empty;
	unsigned long long yld_exp_empty;
	unsigned long long yld_cnt;
										
	/* schedule stats */
	unsigned long long sched_active; //new
	unsigned long long sched_switch;
	unsigned long long sched_cnt;
	unsigned long long sched_idle;

	/* wake stats */
	unsigned long long ttwu_cnt;
	unsigned long long ttwu_local;

	/* latency stats */
	unsigned long long cpu_time;
	unsigned long long delay_time;
	unsigned long long pcnt;
};

struct domain_stats {
	unsigned long long lb_cnt[3];
	unsigned long long lb_balanced[3];
	unsigned long long lb_failed[3];
	unsigned long long lb_pulled[3];
	unsigned long long lb_hot_pulled[3];
	unsigned long long lb_imbalance[3];
	unsigned long long lb_nobusyq[3];
	unsigned long long lb_nobusyg[3];
										
	/* Active load balancing */
	unsigned long long alb_cnt;
	unsigned long long alb_failed;
	unsigned long long alb_pushed;
	
	/* Wake ups */
	unsigned long long ttwu_wake_remote;

	/* Passive load balancing */
	unsigned long long ttwu_move_balance;
										
	/* Affine wakeups */
	unsigned long long ttwu_move_affine;
										
	/* SD_BALANCE_EXEC */
	unsigned long long sbe_cnt;
	unsigned long long sbe_balanced;
	unsigned long long sbe_pushed;

	/* SD_BALANCE_FORK */
	unsigned long long sbf_cnt;
	unsigned long long sbf_balanced;
	unsigned long long sbf_pushed;
};

enum idle_type {
	IDLE,
	NOT_IDLE,
	NEWLY_IDLE,
};

#define MAXDOMAINS	4
#define MAXCPUS		32
#define HZ		100UL

static void parse_file(FILE *file, unsigned long long *ts,
		int *cpus, int *domains,
		struct rq_stats rq_stats[MAXCPUS],
		struct domain_stats domain_stats[MAXCPUS][MAXDOMAINS])
{
	int i, j;
	int ret, cpu, domain;
	int tmp;

	*domains = -1;

	ret = fscanf(file, "version %d\n", &tmp);
	if (ret == 0 || ret == EOF) {
		fprintf(stderr, "file format error 0\n");
		exit(1);
	}
	if (tmp != SCHEDSTAT_VERSION) {
		fprintf(stderr, "wrong file format version\n");
		exit(1);
	}

	ret = fscanf(file, "timestamp %llu\n", ts);
	if (ret == 0 || ret == EOF) {
		fprintf(stderr, "file format error 1\n");
		exit(1);
	}

	for (i = 0; i < MAXCPUS; i++) {
		struct rq_stats *rs = &rq_stats[i];

		ret = fscanf(file, "cpu%d ", &cpu);
		if (ret == EOF)
			break;
		if (ret == 0 || cpu != i) {
			fprintf(stderr, "file format error 2\n");
			exit(1);
		}

		ret = fscanf(file, "%llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu",
			&rs->yld_both_empty, &rs->yld_act_empty,
			&rs->yld_exp_empty, &rs->yld_cnt,
			&rs->sched_switch, &rs->sched_cnt, &rs->sched_idle,
			&rs->ttwu_cnt, &rs->ttwu_local,
			&rs->cpu_time, &rs->delay_time, &rs->pcnt);
		if (ret == 0 || ret == EOF) {
			fprintf(stderr, "file format error 3\n");
			exit(1);
		}
		
		for (j = 0; j < MAXDOMAINS; j++) {
			int k;
			struct domain_stats *ds = &domain_stats[i][j];
			
			/* We discard the domain's cpumask for now */
			ret = fscanf(file, " domain%d %*s", &domain);
			if (ret == 0 || ret == EOF)
				break;
			if (domain != j) {
				fprintf(stderr, "file format error 4\n");
				exit(1);
			}

			for (k = 0; k < 3; k++) {
				ret = fscanf(file, "%llu %llu %llu %llu %llu %llu %llu %llu",
					&ds->lb_cnt[k], &ds->lb_balanced[k],
					&ds->lb_failed[k], &ds->lb_imbalance[k],
					&ds->lb_pulled[k], &ds->lb_hot_pulled[k],
					&ds->lb_nobusyq[k], &ds->lb_nobusyg[k]);
				if (ret == 0 || ret == EOF) {
					fprintf(stderr, "file format error 5\n");
					exit(1);
				}
			}

			ret = fscanf(file, " %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu",
				&ds->alb_cnt, &ds->alb_failed, &ds->alb_pushed,
				&ds->sbe_cnt, &ds->sbe_balanced, &ds->sbe_pushed,
				&ds->sbf_cnt, &ds->sbf_balanced, &ds->sbf_pushed,
				&ds->ttwu_wake_remote, &ds->ttwu_move_affine,
				&ds->ttwu_move_balance);
			if (ret == 0 || ret == EOF) {
				fprintf(stderr, "file format error 6\n");
				exit(1);
			}
		}

		if (*domains != -1 && *domains != j) {
			fprintf(stderr, "domains mismatch within file\n");
			exit(1);
		}
		*domains = j;

		ret = fscanf(file, "\n");
		if (ret == EOF)
			break;
	}
	
	*cpus = i;
}

static void find_stats_delta(struct rq_stats rq_pre[MAXCPUS],
			struct rq_stats rq_post[MAXCPUS],
			struct rq_stats *rq_delta,
			struct domain_stats domain_pre[MAXCPUS][MAXDOMAINS],
			struct domain_stats domain_post[MAXCPUS][MAXDOMAINS],
			struct domain_stats domain_delta[MAXDOMAINS])
{
	int i;

	memset(rq_delta, 0, sizeof(struct rq_stats));
	memset(domain_delta, 0, sizeof(struct domain_stats)*MAXDOMAINS);
	
	for (i = 0; i < MAXCPUS; i++) {
		unsigned int j, k;

		/* No problem because they're all unsigned long long */
		for (j = 0; j < sizeof(struct rq_stats)/sizeof(unsigned long long); j++) {
			*((unsigned long long *)rq_delta + j) +=
			*((unsigned long long *)&rq_post[i] + j) -
			*((unsigned long long *)&rq_pre[i] + j);
		}
		
		for (j = 0; j < MAXDOMAINS; j++) {
			for (k = 0; k < sizeof(struct domain_stats)/sizeof(unsigned long long); k++) {
				*((unsigned long long *)&domain_delta[j] + k) +=
				*((unsigned long long *)&domain_post[i][j] + k) -
				*((unsigned long long *)&domain_pre[i][j] + k);
			}
		}
	}
}

static void show_stats(unsigned long long time_delta, int cpus, int domains,
		struct rq_stats *rq_stats,
		struct domain_stats domain_stats[MAXDOMAINS])
{
	unsigned long long ttwu_remote;
	double s, tmp;
	int i;

	/* Ensures we don't get 0 time delta */
	s = ((double)0.5 + time_delta) / HZ;
	printf("sample period: %.3fs\n", s);
	
	/* TODO add the runqueue stats */
	tmp = (double)rq_stats->sched_cnt / s;
	printf("%.3f calls to schedule / s\n", tmp);

	tmp = (double)rq_stats->cpu_time / rq_stats->pcnt;
	printf("%.3fms average timeslice\n", tmp);

	tmp = (double)rq_stats->delay_time / rq_stats->pcnt;
	printf("%.3fms average runqueue delay\n", tmp);

	printf("\n--- wakeup statistics ---\n");
	tmp = (double)rq_stats->ttwu_cnt / s;
	printf("  %.3f task wakes / s\n", tmp);
	tmp = (double)100 * rq_stats->ttwu_local / rq_stats->ttwu_cnt;
	printf("    %.3f%% of them from the local CPU\n", tmp);

	ttwu_remote = rq_stats->ttwu_cnt - rq_stats->ttwu_local;

	for (i = 0; i < domains; i++) {
		tmp = (double)100 * domain_stats[i].ttwu_wake_remote / ttwu_remote;
		printf("    %.3f%% of remote wakeups come from domain%d\n", tmp, i);

		tmp = (double)100 * domain_stats[i].ttwu_move_balance / domain_stats[i].ttwu_wake_remote;
		printf("      %.3f%% are moved to the local CPU via passive load balancing\n", tmp);

		tmp = (double)100 * domain_stats[i].ttwu_move_affine / domain_stats[i].ttwu_wake_remote;
		printf("      %.3f%% are moved to the local CPU via affine wakeups\n", tmp);
	}

	printf("\n--- load balancing statistics ---\n");

	for (i = 0; i < domains; i++) {
		unsigned long long total_lb = 0;
		unsigned long long total_pulled = 0;
		int j;

		printf("  for domain%d\n", i);

		for (j = 0; j < 3; j++) {
			total_lb += domain_stats[i].lb_cnt[j];
			total_pulled += domain_stats[i].lb_pulled[j];
		}

		tmp = (double)total_lb / s;
		printf("    %.3f load balance calls / s", tmp);
		tmp = (double)total_pulled / s;
		printf(" move %.3f tasks / s\n", tmp);

		for (j = 0; j < 3; j++) {
			unsigned long long lb = domain_stats[i].lb_cnt[j];
			unsigned long long pulled = domain_stats[i].lb_pulled[j];
			tmp = (double)100 * lb / total_lb;
			printf("      %.3f%% calls and", tmp);
			tmp = (double)100 * pulled / total_pulled;
			printf(" %.3f%% task moves came from ", tmp);
			if (j == 0)
				printf("idle balancing\n");
			else if (j == 1)
				printf("busy balancing\n");
			else if (j == 2)
				printf("new-idle balancing\n");

			if (lb) {
				tmp = (double)100 * (lb - domain_stats[i].lb_balanced[j]) / lb;
				printf("        %.3f%% were imbalanced", tmp);

				tmp = (double)domain_stats[i].lb_imbalance[j] / (lb - domain_stats[i].lb_balanced[j]);
				printf(" with an average imbalance of %.3f\n", tmp);

				tmp = (double)100 * domain_stats[i].lb_failed[j] / lb;
				printf("        %.3f%% found an imbalance but failed\n", tmp);
			}

			if (pulled) {
				tmp = (double)100 * domain_stats[i].lb_hot_pulled[j] / pulled;
				printf("        %.3f%% of tasks moved were cache hot\n", tmp);
			}
		}
		
		tmp = (double)domain_stats[i].alb_cnt / s;
		printf("    %.3f active balances / s ", tmp);
		
		tmp = (double)domain_stats[i].alb_pushed / s;
		printf(" move %.3f tasks / s\n", tmp);

		if (domain_stats[i].alb_cnt) {
			tmp = (double)100 * domain_stats[i].alb_failed / domain_stats[i].alb_cnt;
			printf("      %%%.3f attempts failed\n", tmp);
		}

		tmp = (double)domain_stats[i].sbe_cnt / s;
		printf("    %.3f exec balances / s ", tmp);
		
		tmp = (double)domain_stats[i].sbe_pushed / s;
		printf(" move %.3f tasks / s\n", tmp);

		if (domain_stats[i].sbe_cnt) {
			tmp = (double)100 * domain_stats[i].sbe_balanced / domain_stats[i].sbe_cnt;
			printf("      %%%.3f found no imbalance\n", tmp);
		}

		tmp = (double)domain_stats[i].sbf_cnt / s;
		printf("    %.3f fork balances / s ", tmp);
		
		tmp = (double)domain_stats[i].sbf_pushed / s;
		printf(" move %.3f tasks / s\n", tmp);

		if (domain_stats[i].sbf_cnt) {
			tmp = (double)100 * domain_stats[i].sbf_balanced / domain_stats[i].sbf_cnt;
			printf("      %%%.3f found no imbalance\n", tmp);
		}


		printf("\n");
	}
}

static unsigned long long pre_ts, post_ts;
static int pre_cpus, post_cpus;
static int pre_domains, post_domains;
static struct rq_stats pre_rq_stats[MAXCPUS];
static struct rq_stats post_rq_stats[MAXCPUS];
static struct rq_stats delta_rq_stats;
static struct domain_stats pre_domain_stats[MAXCPUS][MAXDOMAINS];
static struct domain_stats post_domain_stats[MAXCPUS][MAXDOMAINS];
static struct domain_stats delta_domain_stats[MAXDOMAINS];

int main(int argc, char *argv[])
{
	FILE *pre, *post;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s <starts before> <stats after>\n",
				argv[0]);
		exit(1);
	}

	pre = fopen(argv[1], "r");
	if (pre == NULL)
		perror("fopen pre file"), exit(1);
	post = fopen(argv[2], "r");
	if (post == NULL)
		perror("fopen post file"), exit(1);

	parse_file(pre, &pre_ts, &pre_cpus, &pre_domains,
			pre_rq_stats, pre_domain_stats);
	parse_file(post, &post_ts, &post_cpus, &post_domains,
			post_rq_stats, post_domain_stats);
	if (pre_cpus != post_cpus || pre_domains != post_domains) {
		fprintf(stderr, "pre and post file formats mismatch\n");
		exit(1);
	}

	find_stats_delta(pre_rq_stats, post_rq_stats, &delta_rq_stats,
		pre_domain_stats, post_domain_stats, delta_domain_stats);

	show_stats(post_ts - pre_ts, pre_cpus, pre_domains,
			&delta_rq_stats, delta_domain_stats);

	exit(0);
}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYDPHSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYDPHSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYDPHSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:18:23 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:6127 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYDPHSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=JeyLrOztp+62GmYtYFWDBXYT6RshjJdIupLb5Zgot8MW/UE2xpukvEUf4jnWTB81USMyIolj3ECiH8HrhUrCyad2go4dpWw+GQtUuEInNY/on5Ag2qZaBfPwhuVcXWFjtR1rHMMARAYyTtVVkC/p/trvTcY5/TFloc4za76ycsU=
Message-ID: <91b13c310804160018p86d20a0p3cbe4ed9b267ba93@mail.gmail.com>
Date: Wed, 16 Apr 2008 15:18:18 +0800
From: "rae l" <crquan@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: iowait stability regressed from kernel 2.6.22 under heavy load of multi-thread aio writing/reading
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <x49k5izme80.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13242_26704533.1208330298121"
References: <91b13c310804110217g1d2c3ee4p69fee6fd43f4abd2@mail.gmail.com>
	 <x49k5izme80.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13242_26704533.1208330298121
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Apr 15, 2008 at 9:37 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>
>  > Now I think the improvements of IO effciency in the development of
>  > 2.6.22 also caused the instability of iowait time, right? but how
>  > to find out? Simple bisecting seems not work.
>
>  Why doesn't bisecting work?  Can you provide your test code so others
>  can verify your findings?
the attachment c file is the test program, compile it with `gcc -Wall
-D_GNU_SOURCE aio-test.c -lrt -lpthread`

and the following is the main logic:
1. main initiates several pthread;
2. each pthread infinitely calls run_once;
3. each run_once opens several file, using aio_write to writes some
arbitrary data;
4. aio_suspend to wait for these POSIX aio;
5. each run_once wait for aio_write all complete, then output the statistics;
6. the program run for ever;

while the program running, we use top,vmstat,iostat to inspect the
system performance, and the result is:
1. kernel 2.6.22/23/24 has better throughput than kernel below 2.6.21,
but worse iowait time;

--------------------------------------------------------------------------------

#define MAX_LIST 1000

char *dir = "/tmp";
int buf_size = 8, files_nr = 4, thread_nr = 2, o_dir = 0;

struct asyc_file {
	struct timeval *t_diff;
	int idx;
};

void aio_complete(sigval_t sigev_value)
{
	int i;
	struct timeval ts, te;
	struct asyc_file *asfp;
	struct timeval *t_diff;

	asfp = sigev_value.sival_ptr;
	t_diff = asfp->t_diff;
	i = asfp->idx;
	gettimeofday(&te, NULL);
	ts = t_diff[i];
	timersub(&te, &ts, &t_diff[i]);

	free(asfp);

	/*
	printf("aio %i, started %f, ended %f, diff %f\n",
			i,
			ts.tv_sec + ts.tv_usec / 1000000.0,
			te.tv_sec + te.tv_usec / 1000000.0,
			t_diff[i].tv_sec + t_diff[i].tv_usec / 1000000.0
			);
			*/
}

/*
 * run in every thread:
 * 	MAX_LIST aio per file descriptor,
 * 	files_nr filedes per thread,
 */

void run_once(void)
{
	struct aiocb my_aiocb[MAX_LIST] = {};
	char buf[buf_size * 1024];
	int i, fds[files_nr], ret;
	unsigned long int pid, tid;
	struct timeval t_diff[MAX_LIST];
	float sum, avg;

	pid = getpid();
	tid = pthread_self();

	for (i = 0; i < files_nr; ++i) {
		snprintf(buf, sizeof buf, "%s/dir1%lu/file1%lu-%li",
				dir, tid, tid, random());
		ret = fds[i] = open(buf,
				O_CREAT|O_WRONLY|O_TRUNC|O_NOATIME| o_dir, 0644);
		if (ret < 0) {
			fprintf(stderr, "open error: %i, %s, "
					"tid %lu of pid %lu exited\n",
					errno, strerror(errno),
					tid, pid);
			pthread_exit(NULL);
		}
	}

	int div = ARRAY_SIZE(t_diff) / files_nr;
	for (i = 0; i < ARRAY_SIZE(t_diff); ++i) {
		struct asyc_file *asfp;

		asfp = calloc(1, sizeof(*asfp));
		asfp->t_diff = t_diff;
		asfp->idx = i;

		int fd_idx = i / div;
		int fd = fds[fd_idx];
		if (isatty(fd) || fd <= 2) {
			fprintf(stderr, "size %i, idx %i, div %i, fd_idx %i, "
					"fd %i, %i, %s\n",
					ARRAY_SIZE(t_diff), i, div, fd_idx,
					fd, errno, strerror(errno));
			pthread_exit(NULL);
		}
		my_aiocb[i].aio_fildes = fd;
		my_aiocb[i].aio_buf = buf;
		my_aiocb[i].aio_nbytes = sizeof buf;
		my_aiocb[i].aio_offset = (i % div) * sizeof buf;

		my_aiocb[i].aio_sigevent.sigev_notify = SIGEV_THREAD;
		my_aiocb[i].aio_sigevent.sigev_notify_function = aio_complete;
		my_aiocb[i].aio_sigevent.sigev_notify_attributes = NULL;
		my_aiocb[i].aio_sigevent.sigev_value.sival_ptr = asfp;

		gettimeofday(&t_diff[i], NULL);
		aio_write(&my_aiocb[i]);

		/* sched_yield(); */
	}

	struct timeval tv;
	struct tm tm;

	/*
	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, &tm);
	strftime(buf, sizeof buf, "%Y%m%d-%H%M%S", &tm);
	printf("%s.%06lu/%lu/%lu/%i aio_write started\n",
			buf, tv.tv_usec,
			pid, tid, ARRAY_SIZE(t_diff)
			);
			*/

	for (i = 0; i < ARRAY_SIZE(t_diff); ++i) {
		const struct aiocb *my_aiocb_p = &my_aiocb[i];
		ret = aio_suspend(&my_aiocb_p, 1, NULL);
		if (ret < 0)
			perror("aio_suspend");
		/*
		else
			printf("aio_suspend %i returned with ret %i\n", i, ret);
			*/
	}

	/*
	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, &tm);
	strftime(buf, sizeof buf, "%Y%m%d-%H%M%S", &tm);
	printf("%s.%06lu/%lu/%lu/%i aio_write completed\n",
			buf, tv.tv_usec,
			pid, tid, ARRAY_SIZE(t_diff)
			);
			*/

	sleep(1);

	int errors = 0;
	for (i = 0; i < ARRAY_SIZE(t_diff); ++i) {
		ret = aio_return(&my_aiocb[i]);
		if (ret < 0)
			errors++;
	}

	for (i = 0; i < files_nr; ++i)
		close(fds[i]);

	sum = 0.0f;
	int valid = 0;
	for (i = 0; i < ARRAY_SIZE(t_diff); ++i) {
		float t = t_diff[i].tv_sec + t_diff[i].tv_usec / 1000000.0;
		if (t > 1199116800.0) /* time_t for 2008/01/01 */
			fprintf(stderr, "timeout for %f\n", t);
		else {
			valid++;
			sum += t;
		}
	}
	avg = sum / valid;

	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, &tm);
	strftime(buf, sizeof buf, "%Y%m%d-%H%M%S", &tm);

	printf("%s.%06lu: pid %lu, tid %lu, total valid %i aio, avg %f, errors %i%%\n",
			buf, tv.tv_usec,
			pid, tid, valid, avg, errors * 100 / ARRAY_SIZE(t_diff));
}

void *per_thread_run(void *parm)
{
	unsigned long int tid;
	char buf[BUFSIZ];
	int ret;

	tid = pthread_self();

	printf("thread %lu started\n", tid);

	snprintf(buf, BUFSIZ, "%s/dir1%lu", dir, tid);
	ret = mkdir(buf, 0755);
	if (ret < 0 && errno != EEXIST) {
		perror("mkdir");
		pthread_exit(NULL);
	}

	while (1)
		run_once();

	return NULL;
}

char *progname;
char *help_message =
"Usage: %s [-d dir] [-t thread_nr] [-b writebuf_size] [-f files_nr] [-h]\n"
"\t-%c\n";

int main(int argc, char *argv[])
{
	int opt;
	int i, ret;
	pthread_t *thread_ids;

	progname = argv[0];

	while ((opt = getopt(argc, argv, "d:t:b:f:oh")) != EOF) {
		switch (opt) {
			case 'd':
				dir = strdup(optarg);
				break;
			case 't':
				thread_nr = atoi(optarg);
				break;
			case 'b':
				buf_size = atoi(optarg);
				break;
			case 'f':
				files_nr = atoi(optarg);
				break;
			case 'o':
				o_dir = O_DIRECT;
				break;
			case '?':
			case 'h':
			default:
				fprintf(stderr, help_message, progname, opt);
				exit(1);
		}
	}

	setlinebuf(stdout);

	struct rlimit rl;
	getrlimit(RLIMIT_NOFILE, &rl);
	printf("curr %lu, max %lu\n", rl.rlim_cur, rl.rlim_max);
	rl.rlim_cur = rl.rlim_max = 10240;
	setrlimit(RLIMIT_NOFILE, &rl);
	getrlimit(RLIMIT_NOFILE, &rl);
	printf("curr %lu, max %lu\n", rl.rlim_cur, rl.rlim_max);

	/* total 5 processes */

	for (i = 0; i < 4; ++i) {
		ret = fork();
		if (ret < 0) {
			perror("fork");
			exit(1);
		}
		if (ret == 0)
			/* break in child */
			break;
	}

	srandom(time(NULL));

	thread_ids = calloc(thread_nr, sizeof(pthread_t));

	for (i = 0; i < thread_nr; ++i)
		pthread_create(&thread_ids[i], NULL, per_thread_run, NULL);

	for (i = 0; i < thread_nr; ++i)
		pthread_join(thread_ids[i], NULL);

	return 0;
}

--------------------------------------------------------------------------------

>  > by the way, a question is how to guarantee a kernel not regress under
>  > heavy multi-thread aio writing load? ltp project seems not give the
>  > answer:
>
>  Well, providing your test code would be a step closer to achieving this
>  guarantee.  If it is scriptable, then there is a chance we could
>  integrate it into the aio-dio regression test suite:
>
>   http://git.kernel.org/?p=linux/kernel/git/zab/aio-dio-regress.git;a=summary
and would aio-dio-regress.git accept POSIX aio regress tests? I have
several POSIX aio_write/read tests.

--
Denis

------=_Part_13242_26704533.1208330298121
Content-Type: text/x-csrc; name=aio-test.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ff3h86xq0
Content-Disposition: attachment; filename=aio-test.c

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0cmluZy5o
PgojaW5jbHVkZSA8ZXJybm8uaD4KCiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN5cy90
aW1lLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNs
dWRlIDxzeXMvcmVzb3VyY2UuaD4KCiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5
cy9zdGF0Lmg+CiNpbmNsdWRlIDxmY250bC5oPgoKI2luY2x1ZGUgPGFpby5oPgojaW5jbHVkZSA8
c2NoZWQuaD4KI2luY2x1ZGUgPHB0aHJlYWQuaD4KCiNkZWZpbmUgQVJSQVlfU0laRShhcnIpIChz
aXplb2YoYXJyKSAvIHNpemVvZigoYXJyKVswXSkpCiNkZWZpbmUgTUFYX0xJU1QgMTAwMAoKY2hh
ciAqZGlyID0gIi90bXAiOwppbnQgYnVmX3NpemUgPSA4LCBmaWxlc19uciA9IDQsIHRocmVhZF9u
ciA9IDIsIG9fZGlyID0gMDsKCnN0cnVjdCBhc3ljX2ZpbGUgewoJc3RydWN0IHRpbWV2YWwgKnRf
ZGlmZjsKCWludCBpZHg7Cn07Cgp2b2lkIGFpb19jb21wbGV0ZShzaWd2YWxfdCBzaWdldl92YWx1
ZSkKewoJaW50IGk7CglzdHJ1Y3QgdGltZXZhbCB0cywgdGU7CglzdHJ1Y3QgYXN5Y19maWxlICph
c2ZwOwoJc3RydWN0IHRpbWV2YWwgKnRfZGlmZjsKCglhc2ZwID0gc2lnZXZfdmFsdWUuc2l2YWxf
cHRyOwoJdF9kaWZmID0gYXNmcC0+dF9kaWZmOwoJaSA9IGFzZnAtPmlkeDsKCWdldHRpbWVvZmRh
eSgmdGUsIE5VTEwpOwoJdHMgPSB0X2RpZmZbaV07Cgl0aW1lcnN1YigmdGUsICZ0cywgJnRfZGlm
ZltpXSk7CgoJZnJlZShhc2ZwKTsKCgkvKgoJcHJpbnRmKCJhaW8gJWksIHN0YXJ0ZWQgJWYsIGVu
ZGVkICVmLCBkaWZmICVmXG4iLAoJCQlpLAoJCQl0cy50dl9zZWMgKyB0cy50dl91c2VjIC8gMTAw
MDAwMC4wLAoJCQl0ZS50dl9zZWMgKyB0ZS50dl91c2VjIC8gMTAwMDAwMC4wLAoJCQl0X2RpZmZb
aV0udHZfc2VjICsgdF9kaWZmW2ldLnR2X3VzZWMgLyAxMDAwMDAwLjAKCQkJKTsKCQkJKi8KfQoK
LyoKICogcnVuIGluIGV2ZXJ5IHRocmVhZDoKICogCU1BWF9MSVNUIGFpbyBwZXIgZmlsZSBkZXNj
cmlwdG9yLAogKiAJZmlsZXNfbnIgZmlsZWRlcyBwZXIgdGhyZWFkLAogKi8KCnZvaWQgcnVuX29u
Y2Uodm9pZCkKewoJc3RydWN0IGFpb2NiIG15X2Fpb2NiW01BWF9MSVNUXSA9IHt9OwoJY2hhciBi
dWZbYnVmX3NpemUgKiAxMDI0XTsKCWludCBpLCBmZHNbZmlsZXNfbnJdLCByZXQ7Cgl1bnNpZ25l
ZCBsb25nIGludCBwaWQsIHRpZDsKCXN0cnVjdCB0aW1ldmFsIHRfZGlmZltNQVhfTElTVF07Cglm
bG9hdCBzdW0sIGF2ZzsKCglwaWQgPSBnZXRwaWQoKTsKCXRpZCA9IHB0aHJlYWRfc2VsZigpOwoK
CWZvciAoaSA9IDA7IGkgPCBmaWxlc19ucjsgKytpKSB7CgkJc25wcmludGYoYnVmLCBzaXplb2Yg
YnVmLCAiJXMvZGlyMSVsdS9maWxlMSVsdS0lbGkiLAoJCQkJZGlyLCB0aWQsIHRpZCwgcmFuZG9t
KCkpOwoJCXJldCA9IGZkc1tpXSA9IG9wZW4oYnVmLAoJCQkJT19DUkVBVHxPX1dST05MWXxPX1RS
VU5DfE9fTk9BVElNRXwgb19kaXIsIDA2NDQpOwoJCWlmIChyZXQgPCAwKSB7CgkJCWZwcmludGYo
c3RkZXJyLCAib3BlbiBlcnJvcjogJWksICVzLCAiCgkJCQkJInRpZCAlbHUgb2YgcGlkICVsdSBl
eGl0ZWRcbiIsCgkJCQkJZXJybm8sIHN0cmVycm9yKGVycm5vKSwKCQkJCQl0aWQsIHBpZCk7CgkJ
CXB0aHJlYWRfZXhpdChOVUxMKTsKCQl9Cgl9CgoJaW50IGRpdiA9IEFSUkFZX1NJWkUodF9kaWZm
KSAvIGZpbGVzX25yOwoJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUodF9kaWZmKTsgKytpKSB7
CgkJc3RydWN0IGFzeWNfZmlsZSAqYXNmcDsKCgkJYXNmcCA9IGNhbGxvYygxLCBzaXplb2YoKmFz
ZnApKTsKCQlhc2ZwLT50X2RpZmYgPSB0X2RpZmY7CgkJYXNmcC0+aWR4ID0gaTsKCgkJaW50IGZk
X2lkeCA9IGkgLyBkaXY7CgkJaW50IGZkID0gZmRzW2ZkX2lkeF07CgkJaWYgKGlzYXR0eShmZCkg
fHwgZmQgPD0gMikgewoJCQlmcHJpbnRmKHN0ZGVyciwgInNpemUgJWksIGlkeCAlaSwgZGl2ICVp
LCBmZF9pZHggJWksICIKCQkJCQkiZmQgJWksICVpLCAlc1xuIiwKCQkJCQlBUlJBWV9TSVpFKHRf
ZGlmZiksIGksIGRpdiwgZmRfaWR4LAoJCQkJCWZkLCBlcnJubywgc3RyZXJyb3IoZXJybm8pKTsK
CQkJcHRocmVhZF9leGl0KE5VTEwpOwoJCX0KCQlteV9haW9jYltpXS5haW9fZmlsZGVzID0gZmQ7
CgkJbXlfYWlvY2JbaV0uYWlvX2J1ZiA9IGJ1ZjsKCQlteV9haW9jYltpXS5haW9fbmJ5dGVzID0g
c2l6ZW9mIGJ1ZjsKCQlteV9haW9jYltpXS5haW9fb2Zmc2V0ID0gKGkgJSBkaXYpICogc2l6ZW9m
IGJ1ZjsKCgkJbXlfYWlvY2JbaV0uYWlvX3NpZ2V2ZW50LnNpZ2V2X25vdGlmeSA9IFNJR0VWX1RI
UkVBRDsKCQlteV9haW9jYltpXS5haW9fc2lnZXZlbnQuc2lnZXZfbm90aWZ5X2Z1bmN0aW9uID0g
YWlvX2NvbXBsZXRlOwoJCW15X2Fpb2NiW2ldLmFpb19zaWdldmVudC5zaWdldl9ub3RpZnlfYXR0
cmlidXRlcyA9IE5VTEw7CgkJbXlfYWlvY2JbaV0uYWlvX3NpZ2V2ZW50LnNpZ2V2X3ZhbHVlLnNp
dmFsX3B0ciA9IGFzZnA7CgoJCWdldHRpbWVvZmRheSgmdF9kaWZmW2ldLCBOVUxMKTsKCQlhaW9f
d3JpdGUoJm15X2Fpb2NiW2ldKTsKCgkJLyogc2NoZWRfeWllbGQoKTsgKi8KCX0KCglzdHJ1Y3Qg
dGltZXZhbCB0djsKCXN0cnVjdCB0bSB0bTsKCgkvKgoJZ2V0dGltZW9mZGF5KCZ0diwgTlVMTCk7
Cglsb2NhbHRpbWVfcigmdHYudHZfc2VjLCAmdG0pOwoJc3RyZnRpbWUoYnVmLCBzaXplb2YgYnVm
LCAiJVklbSVkLSVIJU0lUyIsICZ0bSk7CglwcmludGYoIiVzLiUwNmx1LyVsdS8lbHUvJWkgYWlv
X3dyaXRlIHN0YXJ0ZWRcbiIsCgkJCWJ1ZiwgdHYudHZfdXNlYywKCQkJcGlkLCB0aWQsIEFSUkFZ
X1NJWkUodF9kaWZmKQoJCQkpOwoJCQkqLwoKCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHRf
ZGlmZik7ICsraSkgewoJCWNvbnN0IHN0cnVjdCBhaW9jYiAqbXlfYWlvY2JfcCA9ICZteV9haW9j
YltpXTsKCQlyZXQgPSBhaW9fc3VzcGVuZCgmbXlfYWlvY2JfcCwgMSwgTlVMTCk7CgkJaWYgKHJl
dCA8IDApCgkJCXBlcnJvcigiYWlvX3N1c3BlbmQiKTsKCQkvKgoJCWVsc2UKCQkJcHJpbnRmKCJh
aW9fc3VzcGVuZCAlaSByZXR1cm5lZCB3aXRoIHJldCAlaVxuIiwgaSwgcmV0KTsKCQkJKi8KCX0K
CgkvKgoJZ2V0dGltZW9mZGF5KCZ0diwgTlVMTCk7Cglsb2NhbHRpbWVfcigmdHYudHZfc2VjLCAm
dG0pOwoJc3RyZnRpbWUoYnVmLCBzaXplb2YgYnVmLCAiJVklbSVkLSVIJU0lUyIsICZ0bSk7Cglw
cmludGYoIiVzLiUwNmx1LyVsdS8lbHUvJWkgYWlvX3dyaXRlIGNvbXBsZXRlZFxuIiwKCQkJYnVm
LCB0di50dl91c2VjLAoJCQlwaWQsIHRpZCwgQVJSQVlfU0laRSh0X2RpZmYpCgkJCSk7CgkJCSov
CgoJc2xlZXAoMSk7CgoJaW50IGVycm9ycyA9IDA7Cglmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0la
RSh0X2RpZmYpOyArK2kpIHsKCQlyZXQgPSBhaW9fcmV0dXJuKCZteV9haW9jYltpXSk7CgkJaWYg
KHJldCA8IDApCgkJCWVycm9ycysrOwoJfQoKCWZvciAoaSA9IDA7IGkgPCBmaWxlc19ucjsgKytp
KQoJCWNsb3NlKGZkc1tpXSk7CgoJc3VtID0gMC4wZjsKCWludCB2YWxpZCA9IDA7Cglmb3IgKGkg
PSAwOyBpIDwgQVJSQVlfU0laRSh0X2RpZmYpOyArK2kpIHsKCQlmbG9hdCB0ID0gdF9kaWZmW2ld
LnR2X3NlYyArIHRfZGlmZltpXS50dl91c2VjIC8gMTAwMDAwMC4wOwoJCWlmICh0ID4gMTE5OTEx
NjgwMC4wKSAvKiB0aW1lX3QgZm9yIDIwMDgvMDEvMDEgKi8KCQkJZnByaW50ZihzdGRlcnIsICJ0
aW1lb3V0IGZvciAlZlxuIiwgdCk7CgkJZWxzZSB7CgkJCXZhbGlkKys7CgkJCXN1bSArPSB0OwoJ
CX0KCX0KCWF2ZyA9IHN1bSAvIHZhbGlkOwoKCWdldHRpbWVvZmRheSgmdHYsIE5VTEwpOwoJbG9j
YWx0aW1lX3IoJnR2LnR2X3NlYywgJnRtKTsKCXN0cmZ0aW1lKGJ1Ziwgc2l6ZW9mIGJ1ZiwgIiVZ
JW0lZC0lSCVNJVMiLCAmdG0pOwoKCXByaW50ZigiJXMuJTA2bHU6IHBpZCAlbHUsIHRpZCAlbHUs
IHRvdGFsIHZhbGlkICVpIGFpbywgYXZnICVmLCBlcnJvcnMgJWklJVxuIiwKCQkJYnVmLCB0di50
dl91c2VjLAoJCQlwaWQsIHRpZCwgdmFsaWQsIGF2ZywgZXJyb3JzICogMTAwIC8gQVJSQVlfU0la
RSh0X2RpZmYpKTsKfQoKdm9pZCAqcGVyX3RocmVhZF9ydW4odm9pZCAqcGFybSkKewoJdW5zaWdu
ZWQgbG9uZyBpbnQgdGlkOwoJY2hhciBidWZbQlVGU0laXTsKCWludCByZXQ7CgoJdGlkID0gcHRo
cmVhZF9zZWxmKCk7CgoJcHJpbnRmKCJ0aHJlYWQgJWx1IHN0YXJ0ZWRcbiIsIHRpZCk7CgoJc25w
cmludGYoYnVmLCBCVUZTSVosICIlcy9kaXIxJWx1IiwgZGlyLCB0aWQpOwoJcmV0ID0gbWtkaXIo
YnVmLCAwNzU1KTsKCWlmIChyZXQgPCAwICYmIGVycm5vICE9IEVFWElTVCkgewoJCXBlcnJvcigi
bWtkaXIiKTsKCQlwdGhyZWFkX2V4aXQoTlVMTCk7Cgl9CgoJd2hpbGUgKDEpCgkJcnVuX29uY2Uo
KTsKCglyZXR1cm4gTlVMTDsKfQoKY2hhciAqcHJvZ25hbWU7CmNoYXIgKmhlbHBfbWVzc2FnZSA9
CiJVc2FnZTogJXMgWy1kIGRpcl0gWy10IHRocmVhZF9ucl0gWy1iIHdyaXRlYnVmX3NpemVdIFst
ZiBmaWxlc19ucl0gWy1oXVxuIgoiXHQtJWNcbiI7CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
YXJndltdKQp7CglpbnQgb3B0OwoJaW50IGksIHJldDsKCXB0aHJlYWRfdCAqdGhyZWFkX2lkczsK
Cglwcm9nbmFtZSA9IGFyZ3ZbMF07CgoJd2hpbGUgKChvcHQgPSBnZXRvcHQoYXJnYywgYXJndiwg
ImQ6dDpiOmY6b2giKSkgIT0gRU9GKSB7CgkJc3dpdGNoIChvcHQpIHsKCQkJY2FzZSAnZCc6CgkJ
CQlkaXIgPSBzdHJkdXAob3B0YXJnKTsKCQkJCWJyZWFrOwoJCQljYXNlICd0JzoKCQkJCXRocmVh
ZF9uciA9IGF0b2kob3B0YXJnKTsKCQkJCWJyZWFrOwoJCQljYXNlICdiJzoKCQkJCWJ1Zl9zaXpl
ID0gYXRvaShvcHRhcmcpOwoJCQkJYnJlYWs7CgkJCWNhc2UgJ2YnOgoJCQkJZmlsZXNfbnIgPSBh
dG9pKG9wdGFyZyk7CgkJCQlicmVhazsKCQkJY2FzZSAnbyc6CgkJCQlvX2RpciA9IE9fRElSRUNU
OwoJCQkJYnJlYWs7CgkJCWNhc2UgJz8nOgoJCQljYXNlICdoJzoKCQkJZGVmYXVsdDoKCQkJCWZw
cmludGYoc3RkZXJyLCBoZWxwX21lc3NhZ2UsIHByb2duYW1lLCBvcHQpOwoJCQkJZXhpdCgxKTsK
CQl9Cgl9CgoJc2V0bGluZWJ1ZihzdGRvdXQpOwoKCXN0cnVjdCBybGltaXQgcmw7CglnZXRybGlt
aXQoUkxJTUlUX05PRklMRSwgJnJsKTsKCXByaW50ZigiY3VyciAlbHUsIG1heCAlbHVcbiIsIHJs
LnJsaW1fY3VyLCBybC5ybGltX21heCk7CglybC5ybGltX2N1ciA9IHJsLnJsaW1fbWF4ID0gMTAy
NDA7CglzZXRybGltaXQoUkxJTUlUX05PRklMRSwgJnJsKTsKCWdldHJsaW1pdChSTElNSVRfTk9G
SUxFLCAmcmwpOwoJcHJpbnRmKCJjdXJyICVsdSwgbWF4ICVsdVxuIiwgcmwucmxpbV9jdXIsIHJs
LnJsaW1fbWF4KTsKCgkvKiB0b3RhbCA1IHByb2Nlc3NlcyAqLwoKCWZvciAoaSA9IDA7IGkgPCA0
OyArK2kpIHsKCQlyZXQgPSBmb3JrKCk7CgkJaWYgKHJldCA8IDApIHsKCQkJcGVycm9yKCJmb3Jr
Iik7CgkJCWV4aXQoMSk7CgkJfQoJCWlmIChyZXQgPT0gMCkKCQkJLyogYnJlYWsgaW4gY2hpbGQg
Ki8KCQkJYnJlYWs7Cgl9CgoJc3JhbmRvbSh0aW1lKE5VTEwpKTsKCgl0aHJlYWRfaWRzID0gY2Fs
bG9jKHRocmVhZF9uciwgc2l6ZW9mKHB0aHJlYWRfdCkpOwoKCWZvciAoaSA9IDA7IGkgPCB0aHJl
YWRfbnI7ICsraSkKCQlwdGhyZWFkX2NyZWF0ZSgmdGhyZWFkX2lkc1tpXSwgTlVMTCwgcGVyX3Ro
cmVhZF9ydW4sIE5VTEwpOwoKCWZvciAoaSA9IDA7IGkgPCB0aHJlYWRfbnI7ICsraSkKCQlwdGhy
ZWFkX2pvaW4odGhyZWFkX2lkc1tpXSwgTlVMTCk7CgoJcmV0dXJuIDA7Cn0K
------=_Part_13242_26704533.1208330298121--

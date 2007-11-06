Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbXKFPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbXKFPNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXKFPNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:13:12 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:33411 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXKFPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:13:10 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: problem in follow_hugetlb_page on ppc64 architecture with get_user_pages
Date: Tue, 6 Nov 2007 16:06:04 +0100
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <RAISCH@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, general@lists.openfabrics.org,
       agl@us.ibm.com, Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
References: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com>
In-Reply-To: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711061606.04402.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland!
> We currently see this when testing Infiniband on ppc64 with ehca +
> hugetlbfs.
> From reading the code this should also be an issue on other architectures.
> Roland, Adam, are you aware of anything in this area with mellanox
> Infiniband cards or other usages with I/O adapters?
Below is a testcase demonstrating this problem. You need to install
libhugetlbfs.so and run it as below:
HUGETLB_MORECORE=yes LD_PRELOAD=libhugetlbfs.so ./hugetlb_ibtest 100

This testcase does the following steps (high level desc):
1. malloc two buffers each of 100MB for send and recv
2. register them as memory regions
3. create queue pair QP
4. send data in send buffer using QP to itself (target is then recv buffer)
5. compare those buffers content

It runs fine without libhugetlbsf. If you call it with libhugetlbfs as
above, step 5 will fail. If you do memset() of the buffers before step 2
(register mr), then it runs without errors.
It appears that hugetlb_cow() is called when first write access is performed
after mrs have been registered. That means the testcase is seeing other pages
than the ones registered to the adapter...

I was able reproduce this with mthca on 2.6.23/ppc64 and fc6/intel.

Regards
Nam




#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <malloc.h>
#include <unistd.h>
#include <infiniband/verbs.h>

static unsigned int pagesize;
static unsigned int bufsize=1024*1024*19;

int cmp_data(void *s, void *d, unsigned long len, unsigned long *fail_pos)
{
	unsigned char *cs = s, *cd = d;
	assert(cs);
	assert(cd);
	assert(fail_pos);
	*fail_pos = 0;
	while (len) {
		if (*cs < *cd)
			return -1;
		if (*cs > *cd)
			return 1;
		len--;
		cs++;
		cd++;
		*fail_pos += 1;
	}
	return 0;
}

int hugetlb_ibtest(struct ibv_device* device)
{
	struct ibv_context *context = NULL;
	struct ibv_port_attr port_attr;
	struct ibv_pd *pd = NULL;
	struct ibv_cq *send_cq = NULL;
	struct ibv_cq *recv_cq = NULL;
	struct ibv_qp *qp = NULL;
	struct ibv_mr *send_mr = NULL;
	struct ibv_mr *recv_mr = NULL;
	unsigned char *send_buffer = NULL;
	unsigned char *recv_buffer = NULL;
	int port = 1; // hardcoded for now
	int rc = 0;

	context = ibv_open_device(device);
	assert(context!=NULL);

	// query port
	memset(&port_attr, 0, sizeof(port_attr));
	rc = ibv_query_port(context, port, &port_attr);
	assert(rc==0);

	// pd
	pd = ibv_alloc_pd(context);
	assert(pd!=NULL);

	// ah
	struct ibv_ah_attr ah_attr = {
		.is_global     = 0,
		.dlid          = port_attr.lid,
		.sl            = 0,
		.src_path_bits = 0,
		.port_num      = port,
		.static_rate = 3
	};
	struct ibv_ah *ah = ibv_create_ah(pd, &ah_attr);
	assert(ah!=NULL);

	// send cq
	send_cq = ibv_create_cq(context, 1, NULL, NULL, 0);
	assert(send_cq!=NULL);

	// recv cq
	recv_cq = ibv_create_cq(context, 1, NULL, NULL, 0);
	assert(recv_cq!=NULL);

	// qp
	struct ibv_qp_init_attr attr = {
		.send_cq = send_cq,
		.recv_cq = recv_cq,
		.cap     = {
			.max_send_wr  = 2,
			.max_recv_wr  = 2,
			.max_send_sge = 1,
			.max_recv_sge = 1
		},
		.qp_type = IBV_QPT_RC,
	};
	qp = ibv_create_qp(pd, &attr);
	assert(qp!=NULL);

	// qp RESET -> INIT
	struct ibv_qp_attr qp_attr;
	memset(&qp_attr, 0, sizeof(qp_attr));
	qp_attr.qp_state = IBV_QPS_INIT;
	qp_attr.pkey_index = 0;
	qp_attr.port_num = port;
	qp_attr.qp_access_flags = 0;
	rc = ibv_modify_qp(qp, &qp_attr,
			   IBV_QP_STATE        |
			   IBV_QP_PKEY_INDEX   |
			   IBV_QP_PORT         |
			   IBV_QP_ACCESS_FLAGS);
	assert(rc==0);

	// qp INIT -> RTR
	memset(&qp_attr, 0, sizeof(qp_attr));
	qp_attr.qp_state = IBV_QPS_RTR;
        qp_attr.rq_psn   = 0;
	qp_attr.max_rd_atomic = 1;
	qp_attr.dest_qp_num = qp->qp_num;
	qp_attr.path_mtu = IBV_MTU_2048;
	qp_attr.ah_attr = ah_attr;
	qp_attr.min_rnr_timer = 0;
	rc = ibv_modify_qp(qp, &qp_attr,
			   IBV_QP_STATE | IBV_QP_RQ_PSN |
			   IBV_QP_MAX_DEST_RD_ATOMIC |
			   IBV_QP_DEST_QPN | IBV_QP_PATH_MTU |
			   IBV_QP_AV | IBV_QP_MIN_RNR_TIMER);
	assert(rc==0);

	// qp RTR -> RTS
	memset(&qp_attr, 0, sizeof(qp_attr));
	qp_attr.qp_state = IBV_QPS_RTS;
        qp_attr.sq_psn   = 0;
	qp_attr.max_dest_rd_atomic = 1;
	qp_attr.timeout  = 18;
	qp_attr.retry_cnt  = 1;
	qp_attr.rnr_retry  = 1;
	rc = ibv_modify_qp(qp, &qp_attr,
			   IBV_QP_STATE | IBV_QP_SQ_PSN |
			   IBV_QP_MAX_QP_RD_ATOMIC |
			   IBV_QP_TIMEOUT | IBV_QP_RETRY_CNT |
			   IBV_QP_RNR_RETRY);
	assert(rc==0);

	// mr recv
	recv_buffer = malloc(bufsize);
	assert(recv_buffer);
	unsigned int i;
	recv_mr = ibv_reg_mr(pd, recv_buffer, bufsize,
			     IBV_ACCESS_LOCAL_WRITE);
	assert(recv_mr!=NULL);
	for (i = 0; i < bufsize; i++)
	  	  recv_buffer[i] = ~(i & 0xff);

	// qp post_recv
	rc = ibv_req_notify_cq(recv_cq, 0);
	struct ibv_sge sge_recv = {
		.addr = (uintptr_t) recv_buffer,
		.length = bufsize,
		.lkey = recv_mr->lkey
	};
	struct ibv_recv_wr recv_wr = {
		.next = NULL,
		.wr_id = 0x5003,
		.sg_list = &sge_recv,
		.num_sge = 1
	};
	struct ibv_recv_wr *bad_recv_wr = NULL;
	rc = ibv_post_recv(qp, &recv_wr, &bad_recv_wr);
	assert(rc==0);

	// mr send
	send_buffer = malloc(bufsize);
	assert(send_buffer);
	send_mr = ibv_reg_mr(pd, send_buffer, bufsize,
			     IBV_ACCESS_LOCAL_WRITE);
	assert(send_mr!=NULL);
	for (i = 0; i < bufsize; i++)
	    send_buffer[i] = (i & 0xff);

	rc = ibv_req_notify_cq(send_cq, 0);
	strcpy(send_buffer, "300 lines for one packet");
	int slen = strlen(send_buffer);
	if (bufsize > slen*2+2)
		strcpy(send_buffer+bufsize-slen-1, send_buffer);
	struct ibv_sge sge_send = {
		.addr 	= (uintptr_t) send_buffer,
		.length = bufsize,
		.lkey 	= send_mr->lkey
	};
	struct ibv_send_wr send_wr = {
		.wr_id = 0x71032,
		.sg_list = &sge_send,
		.num_sge = 1,
		.opcode = IBV_WR_SEND,
		.send_flags = IBV_SEND_SIGNALED,
	};
	struct ibv_send_wr *bad_send_wr = NULL;
	rc = ibv_post_send(qp, &send_wr, &bad_send_wr);
	assert(rc==0);

	// poll send completion
	struct ibv_wc wc;
	int ne;
	memset(&wc, 0, sizeof(wc));
	do {
		ne = ibv_poll_cq(send_cq, 1, &wc);
	} while (ne < 1);
	assert(ne==1);
	assert(wc.status==IBV_WC_SUCCESS);

	// poll recv completion
	memset(&wc, 0, sizeof(wc));
	do {
		ne = ibv_poll_cq(recv_cq, 1, &wc);
	} while (ne < 1);
	assert(ne==1);
	assert(wc.status==IBV_WC_SUCCESS);

	// check what we received is what we sent
	printf("send: \"%s\"\n", send_buffer);
	printf("recv: \"%s\"\n", recv_buffer);
	unsigned long fail_pos;
	rc = cmp_data(send_buffer, recv_buffer, bufsize, &fail_pos);
	if (rc) {
		printf("fail_pos=%lx send_buffer=%p recv_buffer=%p "
		     "%02x<>%02x\n", fail_pos, send_buffer, recv_buffer,
		     send_buffer[fail_pos], recv_buffer[fail_pos]);
		FILE *f = fopen("hugetlb_ibtest.log", "w");
		fprintf(f, "fail_pos=%lx send_buffer=%p recv_buffer=%p "
		     "%02x<>%02x\n", fail_pos, send_buffer, recv_buffer,
		     send_buffer[fail_pos], recv_buffer[fail_pos]);
		for (i = 0; i < bufsize; i += 16) {
		  unsigned int j;
		  fprintf(f, "%016lx  %p ", (unsigned long)i, send_buffer + i);
		  for (j = 0; j < 16; j++)
		    fprintf(f, "%02x ", send_buffer[i + j]);
		  fprintf(f, " %p ", recv_buffer + i);
		  for (j = 0; j < 16; j++)
		    fprintf(f, "%02x ", recv_buffer[i + j]);
		  fprintf(f, "\n");
		}
		fclose(f);
		printf("see log file hugetlb_ibtest.log\n");
	}

	// clean up
	rc = ibv_dereg_mr(recv_mr);
	assert(rc==0);

	rc = ibv_dereg_mr(send_mr);
	assert(rc==0);

	rc = ibv_destroy_ah(ah);
	assert(rc==0);

	rc = ibv_destroy_qp(qp);
	assert(rc==0);

	rc = ibv_destroy_cq(send_cq);
	assert(rc==0);

	rc = ibv_destroy_cq(recv_cq);
	assert(rc==0);

	rc = ibv_dealloc_pd(pd);
	assert(rc==0);

	rc = ibv_close_device(context);
	assert(rc==0);

	return rc;
}


int main(int argc, char *argv[])
{
	struct ibv_device **dev_array = ibv_get_device_list(NULL);
	struct ibv_device *device = NULL;
	assert(dev_array!=NULL);
	device = dev_array[0]; // take first IB device
	assert(device!=NULL);
        pagesize = sysconf(_SC_PAGESIZE);;
	printf("pagesize=0x%x\n", pagesize);
	if (argc > 1) {
		int l = atoi(argv[1]);
		if (l)
			bufsize = 1024*1024*l;
	}
	printf("bufsize=0x%x\n", bufsize);
	int rc = hugetlb_ibtest(device);
	assert(rc==0);
        printf("OK!\n");
        return 0;
}


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZLVCsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZLVCsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 21:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZLVCsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 21:48:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:12855 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZLVCsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 21:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ok8E4FeoL7ixVv41iXr5VrA7wYHI4ItiHl3/aBjSoKj1HK6/NnoX08CNKiUYntGavg
         TyNxM58Olri2vnn9BJ29Nm4Lqz8jDRYo4n2S51+Do84EPZWu+HSl0cpQKY+ZCGtYH3g5
         +ijggeXb7OlMbIvXWoMeSDDSK/PROUWhRt/00=
Date: Tue, 22 Dec 2009 05:47:55 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: 2.6.33-rc1: NULL pointer dereference at wb_do_writeback()
Message-ID: <20091222024755.GA5725@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

The kernel is v2.6.33-rc1-154-gf7b84a6ba with few patches from
Frederic's reiserbkl/reiserfs/kill-bkl tree, seems unrelated.

BUG: unable to handle kernel NULL pointer dereference at 00000001
IP: [<c10aec3b>] wb_do_writeback+0x6b/0x1a0
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
Modules linked in: hwmon_vid sata_sil i2c_nforce2

Pid: 993, comm: <AB>lush-8: Not tainted 2.6.33-rc1-00160-gdaa84dd #1 NF7-S/NF7,NF7-V (nVidia-nForce2)/
EIP: 0060:[<c10aec3b>] EFLAGS: 00010246 CPU: 0
EIP is at wb_do_writeback+0x6b/0x1a0
EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 00000000
ESI: ffff94e5 EDI: f6ad024c EBP: f608bf70 ESP: f608bf38
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process <AB>lush-8: (pid: 993, ti=f608a000 task=f65914f0 task.ti=f608a000)
Stack:
 00000002 00000001 00000000 c10aebf0 00000000 00000000 f6ad01a4 00000f1b
<0> 00000292 000001f4 ffff94e5 000001f4 ffff94e5 f6ad01a4 f608bf84 c10aedbb
<0> f6ad0120 f6ad01a4 c107a010 f608bf9c c107a067 00000000 f70a9eec f6ad01a4
Call Trace:
 [<c10aebf0>] ? wb_do_writeback+0x20/0x1a0
 [<c10aedbb>] ? bdi_writeback_task+0x4b/0x80
 [<c107a010>] ? bdi_start_fn+0x0/0xb0
 [<c107a067>] ? bdi_start_fn+0x57/0xb0
 [<c107a010>] ? bdi_start_fn+0x0/0xb0
 [<c103decc>] ? kthread+0x6c/0x80
 [<c103de60>] ? kthread+0x0/0x80
 [<c100303a>] ? kernel_thread_helper+0x6/0x1c
Code: 00 c7 04 24 02 00 00 00 e8 53 1f fa ff 8b 1f 8b 03 0f 18 00 90 39 fb 74
1c 8b 55 e0 8b 42 0c 0f a3 43 10 19 d2 85 d2 75 77 8b 1b <8b> 13 0f 18 02 90 39
df 75 ea 31 db 90 b9 48 ec 0a c1 ba 01 00
EIP: [<c10aec3b>] wb_do_writeback+0x6b/0x1a0 SS:ESP 0068:f608bf38
CR2: 0000000000000001
---[ end trace 6a300b1deaf502c3 ]---


wb_do_writeback+0x6b is 0x115b
it is in get_next_work_item():
%ebx = list_entry_rcu(work->list.next, struct bdi_work, list) = 1


long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
{
    10f0:	55                   	push   %ebp
    10f1:	89 e5                	mov    %esp,%ebp
    10f3:	57                   	push   %edi
    10f4:	56                   	push   %esi
    10f5:	53                   	push   %ebx
    10f6:	83 ec 2c             	sub    $0x2c,%esp
    10f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    10fc:	89 55 d8             	mov    %edx,-0x28(%ebp)
	struct backing_dev_info *bdi = wb->bdi;
    10ff:	8b 78 08             	mov    0x8(%eax),%edi
{
	struct bdi_work *work, *ret = NULL;

	rcu_read_lock();

	list_for_each_entry_rcu(work, &bdi->work_list, list) {
    1102:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    1109:	81 c7 e8 00 00 00    	add    $0xe8,%edi
    110f:	90                   	nop
 */
static inline void rcu_read_lock(void)
{
	__rcu_read_lock();
	__acquire(RCU);
	rcu_read_acquire();
    1110:	31 c9                	xor    %ecx,%ecx
    1112:	31 d2                	xor    %edx,%edx
    1114:	b8 00 00 00 00       	mov    $0x0,%eax
    1119:	c7 44 24 0c 10 11 00 	movl   $0x1110,0xc(%esp)
    1120:	00 
    1121:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1128:	00 
    1129:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1130:	00 
    1131:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1138:	e8 fc ff ff ff       	call   1139 <wb_do_writeback+0x49>
    113d:	8b 1f                	mov    (%edi),%ebx
    113f:	8b 03                	mov    (%ebx),%eax
    1141:	8d 44 20 00          	lea    0x0(%eax,%eiz,1),%eax
    1145:	39 fb                	cmp    %edi,%ebx
    1147:	74 1c                	je     1165 <wb_do_writeback+0x75>
    1149:	8b 55 e0             	mov    -0x20(%ebp),%edx
    114c:	8b 42 0c             	mov    0xc(%edx),%eax

static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
{
	int oldbit;

	asm volatile("bt %2,%1\n\t"
    114f:	0f a3 43 10          	bt     %eax,0x10(%ebx)
    1153:	19 d2                	sbb    %edx,%edx
		if (!test_bit(wb->nr, &work->seen))
    1155:	85 d2                	test   %edx,%edx
    1157:	75 77                	jne    11d0 <wb_do_writeback+0xe0>
{
	struct bdi_work *work, *ret = NULL;

	rcu_read_lock();

	list_for_each_entry_rcu(work, &bdi->work_list, list) {
    1159:	8b 1b                	mov    (%ebx),%ebx
    115b:	8b 13                	mov    (%ebx),%edx
    115d:	8d 44 20 00          	lea    0x0(%eax,%eiz,1),%eax
    1161:	39 df                	cmp    %ebx,%edi
    1163:	75 ea                	jne    114f <wb_do_writeback+0x5f>
	if (IS_IMMEDIATE(nr)) {
		asm volatile(LOCK_PREFIX "andb %1,%0"
			: CONST_MASK_ADDR(nr, addr)
			: "iq" ((u8)~CONST_MASK(nr)));
	} else {
		asm volatile(LOCK_PREFIX "btr %1,%0"
    1165:	31 db                	xor    %ebx,%ebx
    1167:	90                   	nop
 *
 * See rcu_read_lock() for more information.
 */
static inline void rcu_read_unlock(void)
{
	rcu_read_release();
    1168:	b9 68 11 00 00       	mov    $0x1168,%ecx
    116d:	ba 01 00 00 00       	mov    $0x1,%edx
    1172:	b8 00 00 00 00       	mov    $0x0,%eax
    1177:	e8 fc ff ff ff       	call   1178 <wb_do_writeback+0x88>
{
	struct backing_dev_info *bdi = wb->bdi;
	struct bdi_work *work;
	long wrote = 0;

	while ((work = get_next_work_item(bdi, wb)) != NULL) {
    117c:	85 db                	test   %ebx,%ebx
    117e:	74 78                	je     11f8 <wb_do_writeback+0x108>
		struct wb_writeback_args args = work->args;
    1180:	8b 43 18             	mov    0x18(%ebx),%eax

		/*
		 * Override sync mode, in case we must wait for completion
		 */
		if (force_wait)
    1183:	8b 75 d8             	mov    -0x28(%ebp),%esi
	struct backing_dev_info *bdi = wb->bdi;
	struct bdi_work *work;
	long wrote = 0;

	while ((work = get_next_work_item(bdi, wb)) != NULL) {
		struct wb_writeback_args args = work->args;
    1186:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1189:	8b 43 1c             	mov    0x1c(%ebx),%eax

		/*
		 * Override sync mode, in case we must wait for completion
		 */
		if (force_wait)
    118c:	85 f6                	test   %esi,%esi
	struct backing_dev_info *bdi = wb->bdi;
	struct bdi_work *work;
	long wrote = 0;

	while ((work = get_next_work_item(bdi, wb)) != NULL) {
		struct wb_writeback_args args = work->args;
    118e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1191:	8b 43 20             	mov    0x20(%ebx),%eax
    1194:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1197:	8b 43 24             	mov    0x24(%ebx),%eax
    119a:	89 45 f0             	mov    %eax,-0x10(%ebp)

		/*
		 * Override sync mode, in case we must wait for completion
		 */
		if (force_wait)
    119d:	74 0e                	je     11ad <wb_do_writeback+0xbd>
			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
    119f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    11a6:	c7 43 20 01 00 00 00 	movl   $0x1,0x20(%ebx)

		/*
		 * If this isn't a data integrity operation, just notify
		 * that we have seen this work and we are now starting it.
		 */
		if (args.sync_mode == WB_SYNC_NONE)
    11ad:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    11b0:	85 c9                	test   %ecx,%ecx
    11b2:	74 24                	je     11d8 <wb_do_writeback+0xe8>
			wb_clear_pending(wb, work);

		wrote += wb_writeback(wb, &args);
    11b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11b7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
    11ba:	e8 01 fd ff ff       	call   ec0 <wb_writeback>

		/*
		 * This is a data integrity writeback, so only do the
		 * notification when we have completed the work.
		 */
		if (args.sync_mode == WB_SYNC_ALL)
    11bf:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
		 * that we have seen this work and we are now starting it.
		 */
		if (args.sync_mode == WB_SYNC_NONE)
			wb_clear_pending(wb, work);

		wrote += wb_writeback(wb, &args);
    11c3:	89 c6                	mov    %eax,%esi

		/*
		 * This is a data integrity writeback, so only do the
		 * notification when we have completed the work.
		 */
		if (args.sync_mode == WB_SYNC_ALL)
    11c5:	74 21                	je     11e8 <wb_do_writeback+0xf8>
		 * that we have seen this work and we are now starting it.
		 */
		if (args.sync_mode == WB_SYNC_NONE)
			wb_clear_pending(wb, work);

		wrote += wb_writeback(wb, &args);
    11c7:	01 75 dc             	add    %esi,-0x24(%ebp)
    11ca:	e9 41 ff ff ff       	jmp    1110 <wb_do_writeback+0x20>
    11cf:	90                   	nop
    11d0:	0f b3 43 10          	btr    %eax,0x10(%ebx)
    11d4:	eb 92                	jmp    1168 <wb_do_writeback+0x78>
    11d6:	66 90                	xchg   %ax,%ax
		/*
		 * If this isn't a data integrity operation, just notify
		 * that we have seen this work and we are now starting it.
		 */
		if (args.sync_mode == WB_SYNC_NONE)
			wb_clear_pending(wb, work);
    11d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11db:	89 da                	mov    %ebx,%edx
    11dd:	e8 7e fe ff ff       	call   1060 <wb_clear_pending>
    11e2:	eb d0                	jmp    11b4 <wb_do_writeback+0xc4>
    11e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		/*
		 * This is a data integrity writeback, so only do the
		 * notification when we have completed the work.
		 */
		if (args.sync_mode == WB_SYNC_ALL)
			wb_clear_pending(wb, work);
    11e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11eb:	89 da                	mov    %ebx,%edx
    11ed:	e8 6e fe ff ff       	call   1060 <wb_clear_pending>
    11f2:	eb d3                	jmp    11c7 <wb_do_writeback+0xd7>
    11f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static long wb_check_old_data_flush(struct bdi_writeback *wb)
{
	unsigned long expired;
	long nr_pages;

	expired = wb->last_old_flush +
    11f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11fb:	8b 58 10             	mov    0x10(%eax),%ebx
    11fe:	a1 00 00 00 00       	mov    0x0,%eax
    1203:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    120a:	8d 04 42             	lea    (%edx,%eax,2),%eax
    120d:	e8 fc ff ff ff       	call   120e <wb_do_writeback+0x11e>
			msecs_to_jiffies(dirty_writeback_interval * 10);
	if (time_before(jiffies, expired))
    1212:	8b 15 00 00 00 00    	mov    0x0,%edx
    1218:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
    121b:	39 da                	cmp    %ebx,%edx
    121d:	78 27                	js     1246 <wb_do_writeback+0x156>
		return 0;

	wb->last_old_flush = jiffies;
    121f:	a1 00 00 00 00       	mov    0x0,%eax
    1224:	8b 55 e0             	mov    -0x20(%ebp),%edx
    1227:	89 42 10             	mov    %eax,0x10(%edx)
 *
 * Atomically reads the value of @v.
 */
static inline int atomic_read(const atomic_t *v)
{
	return v->counter;
    122a:	a1 28 00 00 00       	mov    0x28,%eax
    122f:	8b 15 40 00 00 00    	mov    0x40,%edx
	nr_pages = global_page_state(NR_FILE_DIRTY) +
    1235:	8d 04 02             	lea    (%edx,%eax,1),%eax
    1238:	03 05 00 00 00 00    	add    0x0,%eax
			global_page_state(NR_UNSTABLE_NFS) +
			(inodes_stat.nr_inodes - inodes_stat.nr_unused);

	if (nr_pages) {
    123e:	2b 05 04 00 00 00    	sub    0x4,%eax
    1244:	75 12                	jne    1258 <wb_do_writeback+0x168>
			.sync_mode	= WB_SYNC_NONE,
			.for_kupdate	= 1,
			.range_cyclic	= 1,
		};

		return wb_writeback(wb, &args);
    1246:	31 c0                	xor    %eax,%eax
    1248:	03 45 dc             	add    -0x24(%ebp),%eax
	 * Check for periodic writeback, kupdated() style
	 */
	wrote += wb_check_old_data_flush(wb);

	return wrote;
}
    124b:	83 c4 2c             	add    $0x2c,%esp
    124e:	5b                   	pop    %ebx
    124f:	5e                   	pop    %esi
    1250:	5f                   	pop    %edi
    1251:	c9                   	leave  
    1252:	c3                   	ret    
    1253:	90                   	nop
    1254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		struct wb_writeback_args args = {
			.nr_pages	= nr_pages,
			.sync_mode	= WB_SYNC_NONE,
			.for_kupdate	= 1,
			.range_cyclic	= 1,
		};
    1258:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		return wb_writeback(wb, &args);
    125b:	8b 45 e0             	mov    -0x20(%ebp),%eax
    125e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
		struct wb_writeback_args args = {
			.nr_pages	= nr_pages,
			.sync_mode	= WB_SYNC_NONE,
			.for_kupdate	= 1,
			.range_cyclic	= 1,
		};
    1261:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1268:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    126f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1276:	c6 45 f0 03          	movb   $0x3,-0x10(%ebp)

		return wb_writeback(wb, &args);
    127a:	e8 41 fc ff ff       	call   ec0 <wb_writeback>
    127f:	03 45 dc             	add    -0x24(%ebp),%eax
	 * Check for periodic writeback, kupdated() style
	 */
	wrote += wb_check_old_data_flush(wb);

	return wrote;
}
    1282:	83 c4 2c             	add    $0x2c,%esp
    1285:	5b                   	pop    %ebx
    1286:	5e                   	pop    %esi
    1287:	5f                   	pop    %edi
    1288:	c9                   	leave  
    1289:	c3                   	ret    
    128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

